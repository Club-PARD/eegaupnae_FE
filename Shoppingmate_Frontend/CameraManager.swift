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

//@MainActor
final class CameraManager: NSObject, ObservableObject {
    
    // SwiftUI에서 관찰할 상태
    @Published var recognizedText: String = ""
    @Published var isProcessing = false
    @Published var croppedROIImage: UIImage? = nil // ROI로 잘린 이미지 저장 변수
    
    // 카메라 세션
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue") // 세션 제어 전용 백그라운드 만들기
    
    // 프리뷰 레이어 (좌표 변환용)
    // - SwiftUI CameraPreview(UIViewRepresentable)에서 생성된 previewLayer를 여기로 주입해야 함
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // SwiftUI에서 계산한 ROI (previewLayer 좌표계)
    // - ROIOverlay에서 계산한 CGRect를 updateROIRect로 계속 넣어줌
    fileprivate var roiLayerRect: CGRect = .zero
    
    // MARK: - Session 설정
    func startSession() {
        sessionQueue.async {
            if self.session.isRunning { return }
            
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            
            guard
                let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                     for: .video,
                                                     position: .back),
                let input = try? AVCaptureDeviceInput(device: device),
                self.session.canAddInput(input)
            else {
                print("❌ Camera input error")
                return
            }
            
            self.session.addInput(input)
            
            guard self.session.canAddOutput(self.photoOutput) else {
                print("❌ Photo output error")
                return
            }
            
            self.session.addOutput(self.photoOutput)
            
            self.session.commitConfiguration()
            self.session.startRunning() // ✅ 백그라운드
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    // SwiftUI ROI 전달
    @MainActor
    func updateROIRect(_ rect: CGRect) {
        roiLayerRect = rect
    }
    
    // MARK: - 사진 촬영
    func capturePhoto() {
        sessionQueue.async {
            guard self.session.isRunning else { return }
            
            let settings = AVCapturePhotoSettings()
            
            if let conn = self.photoOutput.connection(with: .video) {
                       if conn.isVideoRotationAngleSupported(0) {
                           conn.videoRotationAngle = 0   // portrait
                       }
                   }
            
            Task { @MainActor in
                        self.isProcessing = true

                        if let layer = self.previewLayer {
                            let b = layer.bounds
                            let rect = CGRect(
                                x: b.width * 0.1,
                                y: b.height * 0.4,
                                width: b.width * 0.8,
                                height: b.height * 0.2
                            )
                            self.roiLayerRect = rect
                            print("📌 forced roiLayerRect:", rect)
                            print("📌 layer.bounds:", b)
                        } else {
                            print("❌ previewLayer is nil at capture")
                        }
                    }
            
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }
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
                
                guard let data = photo.fileDataRepresentation() else { return }
                
                // ✅ MainActor에서 UIKit 작업 처리
                Task { @MainActor in
                    guard let rawImage = UIImage(data: data) else {
                        self.isProcessing = false
                        return
                    }
                    
                    // ✅ 여기서 정규화 (MainActor OK)
                    let image = rawImage.normalizedUp()               // orientation 메타 정리

                    
                    guard let cgImage = image.cgImage else {
                        self.isProcessing = false
                        return
                    }
                    
                    let layer = self.previewLayer
                    let roi = self.roiLayerRect
                    let uiOrientation = rawImage.imageOrientation
                    let scale = rawImage.scale
                    
                    guard let layer else {
                        self.isProcessing = false
                        return
                    }
                    

                    Task.detached { [layer, roi] in
                        let cropped = CameraManager.cropToROI(
                            cgImage: cgImage,
                            previewLayer: layer,
                            roiLayerRect: roi
                        )
                        
                        let text = CameraManager.performOCR(
                            cgImage: cgImage,
                            previewLayer: layer,
                            roiLayerRect: roi
                        )
                        
                        await MainActor.run {
                            self.croppedROIImage = cropped
                            self.recognizedText = text
                            self.isProcessing = false
                        }
                    }
                }
            }
        }
        
        // MARK: - OCR (Vision)
        extension CameraManager {
            
            // MainActor와 분리된 "순수 OCR 함수"
            // - background(Task.detached)에서 안전하게 호출 가능
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
            
            
            nonisolated
            static func cropToROI( //ROI 크롭 합수
                cgImage: CGImage,
                previewLayer: AVCaptureVideoPreviewLayer,
                roiLayerRect: CGRect
            ) -> UIImage? {
                
                let metadataROI = previewLayer.metadataOutputRectConverted(fromLayerRect: roiLayerRect)
                print("roiLayerRect:", roiLayerRect)
                print("previewLayer bounds:", previewLayer.bounds)
                print("metadataROI:", metadataROI)
                
                let W = CGFloat(cgImage.width)
                let H = CGFloat(cgImage.height)
                
                var rect = CGRect(
                    x: metadataROI.origin.x * W,
                    y: (1 - metadataROI.origin.y - metadataROI.size.height) * H,
                    width: metadataROI.size.width * W,
                    height: metadataROI.size.height * H
                ).integral
                
                rect = rect.intersection(CGRect(x: 0, y: 0, width: W, height: H))
                guard !rect.isNull, rect.width > 1, rect.height > 1 else { return nil }
                
                guard let croppedCG = cgImage.cropping(to: rect) else { return nil }
                return UIImage(cgImage: croppedCG)
            }
            
}





extension UIImage {
    // imageOrientation(메타) 를 픽셀에 반영해서 실제로 .up인 이미지로 만들어줌
    func normalizedUp() -> UIImage {
        if imageOrientation == .up { return self }
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1   // 원본 픽셀 기준으로 처리(추천)
        
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
}
