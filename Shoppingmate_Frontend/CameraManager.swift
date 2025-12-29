//
//  CameraManager.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/26/25.
//
import AVFoundation
import Vision
import UIKit
import SwiftUI
import Combine

@MainActor
final class CameraManager: NSObject, ObservableObject {

    // SwiftUI에서 관찰할 상태
    @Published var recognizedText: String = ""
    @Published var isProcessing = false

    // 카메라 세션 (엔진의 중심)
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()

    // 프리뷰 레이어 (좌표 변환용)
    // - SwiftUI CameraPreview(UIViewRepresentable)에서 생성된 previewLayer를 여기로 주입해야 함
    var previewLayer: AVCaptureVideoPreviewLayer?

    // SwiftUI에서 계산한 ROI (previewLayer 좌표계)
    // - ROIOverlay에서 계산한 CGRect를 updateROIRect로 계속 넣어줌
    fileprivate var roiLayerRect: CGRect = .zero

    // MARK: - Session 설정
    func startSession() {
        if session.isRunning { return }

        session.beginConfiguration()
        session.sessionPreset = .photo

        // 카메라 디바이스
        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                 for: .video,
                                                 position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            print("❌ Camera input error")
            return
        }
        session.addInput(input)

        // 사진 촬영 output
        guard session.canAddOutput(photoOutput) else {
            print("❌ Photo output error")
            return
        }
        session.addOutput(photoOutput)

        session.commitConfiguration()
        session.startRunning()
    }

    func stopSession() {
        session.stopRunning()
    }

    // SwiftUI ROI 전달
    func updateROIRect(_ rect: CGRect) {
        roiLayerRect = rect
    }

    // MARK: - 사진 촬영
    func capturePhoto() {
        isProcessing = true
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraManager: AVCapturePhotoCaptureDelegate {

    /// Delegate는 메인 액터 밖에서 호출될 수 있어서 nonisolated로 둠
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput,
                                 didFinishProcessingPhoto photo: AVCapturePhoto,
                                 error: Error?) {

        if let error {
            print("❌ Capture error:", error)
            return
        }

        guard
            let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data),
            let cgImage = image.cgImage
        else { return }

        // ✅ @MainActor 속성(previewLayer/roiLayerRect)은 메인 액터에서만 읽을 수 있음
        Task { @MainActor in
            let layer = self.previewLayer
            let roi = self.roiLayerRect

            guard let layer else {
                self.isProcessing = false
                return
            }

            // ✅ 무거운 OCR은 백그라운드에서
            Task.detached { [layer, roi] in
                let text = CameraManager.performOCR(
                    cgImage: cgImage,
                    previewLayer: layer,
                    roiLayerRect: roi
                )

                // ✅ UI 상태 업데이트는 메인 액터에서
                await MainActor.run {
                    self.recognizedText = text
                    self.isProcessing = false
                }
            }
        }
    }
}

// MARK: - OCR (Vision)
extension CameraManager {
    
    /// MainActor와 분리된 "순수 OCR 함수"
    /// - background(Task.detached)에서 안전하게 호출 가능
    nonisolated
    static func performOCR(
        cgImage: CGImage,
        previewLayer: AVCaptureVideoPreviewLayer,
        roiLayerRect: CGRect
    ) -> String {
        
        // 1) SwiftUI ROI(layer 좌표) -> 카메라 정규화 좌표(0~1, origin=top-left)
        let metadataROI =
        previewLayer.metadataOutputRectConverted(fromLayerRect: roiLayerRect)
        
        // 2) Vision ROI는 origin이 bottom-left라서 y를 뒤집어야 함
        let visionROI = CGRect(
            x: metadataROI.origin.x,
            y: 1 - metadataROI.origin.y - metadataROI.height,
            width: metadataROI.width,
            height: metadataROI.height
        )
        
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.regionOfInterest = visionROI
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["ko-KR", "en-US"]
        request.automaticallyDetectsLanguage = false
 
        
        // ⚠️ 기기 방향에 따라 달라질 수 있음 (일단 portrait 기준으로 .right)
        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: .up,
            options: [:]
        )
        
        do {
            try handler.perform([request])
        } catch {
            return "❌ Vision error: \(error.localizedDescription)"
        }
        
        let results = request.results as? [VNRecognizedTextObservation] ?? []

        return results
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
    }
}
