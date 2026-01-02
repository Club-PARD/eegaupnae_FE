////
////  CameraManager.swift
////  Shoppingmate_Frontend
////
////  Created by Jinsoo Park on 12/26/25.
////
//import AVFoundation
//import Vision
//import UIKit
//import SwiftUI
//import Combine//@Published (ObservableObject용)
//import CoreLocation
//
//@MainActor//이 클래스의 기본 실행 컨텍스트는 메인 스레드(UI 상태(@Published) 안전)
////NSObject: AVCapturePhotoCaptureDelegate를 쓰기 위해 필요
//final class CameraManager: NSObject, ObservableObject {
//    
//    private let locationService = LocationService()
//    private let uploadService = UploadService()
//    private var capturedLocation: CLLocation?
//
//    // SwiftUI에서 관찰할 상태
//    @Published var recognizedText: String = ""//OCR 결과 문자열
//    @Published var isProcessing = false//OCR 중인지 여부(로딩 UI용)
//
//    // 카메라 세션 (엔진의 중심)
//    let session = AVCaptureSession()
//    private let photoOutput = AVCapturePhotoOutput()//photoOutput: 실제 사진 촬영 담당
//
//    // 프리뷰 레이어 (좌표 변환용)
//    // - SwiftUI CameraPreview(UIViewRepresentable)에서 생성된 previewLayer를 여기로 주입해야 함
//    //카메라 화면을 보여주는 레이어
//    var previewLayer: AVCaptureVideoPreviewLayer?
//
//    // SwiftUI에서 계산한 ROI (previewLayer 좌표계)
//    // - ROIOverlay에서 계산한 CGRect를 updateROIRect로 계속 넣어줌
//    // vision에서 쓰기 전에 좌표계 변환됨
//    fileprivate var roiLayerRect: CGRect = .zero
//
//    // MARK: - Session 설정
//    func startSession() {
//        if session.isRunning { return }//중복 실행 방지
//
//        session.beginConfiguration()// 카메라 설정 시작
//        session.sessionPreset = .photo //사진 촬영 최적화 프리셋
//
//        // 카메라 디바이스
//        guard
//            // 후면 카메라 가져오기
//            let device = AVCaptureDevice.default(.builtInWideAngleCamera,
//                                                 for: .video,
//                                                 position: .back),
//            let input = try? AVCaptureDeviceInput(device: device),
//            // 카메라를 세션 입력으로 연결
//            session.canAddInput(input)
//        else {
//            print("❌ Camera input error")
//            return
//        }
//        session.addInput(input)// 카메라 입력 등록
//
//        // 사진 촬영 output 등록
//        guard session.canAddOutput(photoOutput) else {
//            print("❌ Photo output error")
//            return
//        }
//        session.addOutput(photoOutput)
//
//        session.commitConfiguration()// 설정 완료
//        session.startRunning()// 카메라 실제 작동 시작
//    }
//
//    // 화면 사라질 때 카메라 중지
//    func stopSession() {
//        session.stopRunning()
//    }
//
//    // SwiftUI ROI 전달
//    // ROIOverlay에서 계산된 영역을 저장
//    func updateROIRect(_ rect: CGRect) {
//        roiLayerRect = rect
//    }
//    
//    func sendToServer(imageData: Data) {
//        let locationDTO = capturedLocation?.toDTO()
//
//        Task {
//            try await uploadService.uploadLocation(
////                imageData: imageData,
////                recognizedText: recognizedText,
//                location: locationDTO
//            )
//        }
//    }
//    
//    func debugPrintLocation() {
//        if let location = capturedLocation {
//            print("📍 latitude:", location.coordinate.latitude)
//            print("📍 longitude:", location.coordinate.longitude)
//        } else {
//            print("❌ location is nil")
//        }
//    }
//    
//    func debugPrintLocationDTO() {
//        guard let dto = capturedLocation?.toDTO() else {
//            print("❌ LocationDTO is nil")
//            return
//        }
//
//        print("📦 LocationDTO")
//        print(" - latitude:", dto.latitude)
//        print(" - longitude:", dto.longitude)
//    }
//    
//    func sendLocationToServer() {
//        guard let locationDTO = capturedLocation?.toDTO() else {
//            print("❌ locationDTO is nil")
//            return
//        }
//
//        Task {
//            do {
//                try await uploadService.uploadLocation(location: locationDTO)
//                print("✅ location upload success")
//            } catch {
//                print("🚨 location upload failed:", error)
//            }
//        }
//    }
//    
//    // MARK: - 사진 촬영
//    // 사진 촬영 시작, 결과는 delegate로 들어옴
//    func capturePhoto() {
//        isProcessing = true
//        locationService.start()
//        let settings = AVCapturePhotoSettings()
//        photoOutput.capturePhoto(with: settings, delegate: self)
//    }
//}
//
//// MARK: - AVCapturePhotoCaptureDelegate
//extension CameraManager: AVCapturePhotoCaptureDelegate {
//
//    // Delegate는 메인 액터 밖에서 호출될 수 있어서 nonisolated로 둠
//    nonisolated func photoOutput(_ output: AVCapturePhotoOutput,
//                                 didFinishProcessingPhoto photo: AVCapturePhoto,
//                                 error: Error?) {
//
//        if let error {
//            print("❌ Capture error:", error)
//            return
//        }
//
//        guard
//            // 촬영된 사진 -> UIImage -> CGImage (Vision은 CGImage 필요)
//            let data = photo.fileDataRepresentation(),
//            let image = UIImage(data: data),
//            let cgImage = image.cgImage
//        else { return }
//
//        // @MainActor 속성(previewLayer/roiLayerRect)은 메인 액터에서만 읽을 수 있음
//        Task { @MainActor in
//            self.capturedLocation = self.locationService.currentLocation
//            self.debugPrintLocation()
//            self.debugPrintLocationDTO()
//            self.sendLocationToServer()
//            let layer = self.previewLayer
//            let roi = self.roiLayerRect
//
//            guard let layer else {
//                self.isProcessing = false
//                return
//            }
//
//            // 무거운 OCR은 백그라운드 스레드에서
//            Task.detached { [layer, roi] in
//                // 순수 OCR 함수 호출
//                let text = CameraManager.performOCR(
//                    cgImage: cgImage,
//                    previewLayer: layer,
//                    roiLayerRect: roi
//                )
//
//                // UI 상태 업데이트는 메인 액터에서
//                await MainActor.run {
//                    self.recognizedText = text
//                    self.isProcessing = false
//                    self.capturedLocation = self.locationService.currentLocation
//                }
//            }
//        } // task
//    }
//}
//
//// MARK: - OCR (Vision)
//extension CameraManager {
//    
//    // MainActor와 분리된 "순수 OCR 함수"
//    // - background(Task.detached)에서 안전하게 호출 가능
//    // nonisolated: 어느 스레드에서도 호출 가능
//    // static: 상태 없는 순수 함수
//    nonisolated static func performOCR(
//        cgImage: CGImage,
//        previewLayer: AVCaptureVideoPreviewLayer,
//        roiLayerRect: CGRect
//    ) -> String {
//        
//        // 1) SwiftUI ROI(layer 좌표) -> 카메라 정규화 좌표(0~1, origin=top-left)
//        let metadataROI =
//        previewLayer.metadataOutputRectConverted(fromLayerRect: roiLayerRect)// SwiftUI 좌표 -> 카메라 메타데이터 좌표(0~1)
//        
//        // 2) Vision ROI는 origin이 bottom-left라서 y를 뒤집어야 함
//        let visionROI = CGRect(
//            x: metadataROI.origin.x,// Vision 좌표계는 좌하단 origin
//            y: 1 - metadataROI.origin.y - metadataROI.height,// y축 뒤집기
//            width: metadataROI.width,
//            height: metadataROI.height
//        )
//    
//        let request = VNRecognizeTextRequest()// OCR 요청 객체
//        request.recognitionLevel = .accurate
//        request.regionOfInterest = visionROI// ROI 내부만 OCR
//        request.usesLanguageCorrection = true
//        request.recognitionLanguages = ["ko-KR", "en-US"]
//        request.automaticallyDetectsLanguage = false
// 
//        
//        // ⚠️ 기기 방향에 따라 달라질 수 있음 (일단 portrait 기준으로 .right)
//        let handler = VNImageRequestHandler(
//            cgImage: cgImage,
//            orientation: .up,
//            options: [:]
//        )
//        
//        do {
//            try handler.perform([request])
//        } catch {
//            return "❌ Vision error: \(error.localizedDescription)"
//        }
//        
//        let results = request.results as? [VNRecognizedTextObservation] ?? []
//
//        // OCR 결과 문자열 합치기
//        return results
//                .compactMap { $0.topCandidates(1).first?.string }
//                .joined(separator: "\n")
//    }
//}
