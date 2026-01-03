////
////  CameraManager.swift
////  Shoppingmate_Frontend
////
////  Created by Jinsoo Park on 12/26/25.

import AVFoundation
import Vision
import UIKit
import Combine//@Published (ObservableObject용)
import CoreLocation

//@MainActor
final class CameraManager: NSObject, ObservableObject {
    
    private let locationService = LocationService()
    private let uploadService = UploadService()
    private var capturedLocation: CLLocation?
    
    // SwiftUI에서 관찰할 상태
    @Published var recognizedText: String = "" //OCR 결과 출력
    @Published var isProcessing = false //OCR 로딩 중
    @Published var croppedROIImage: UIImage? = nil // ROI로 잘린 이미지 저장 변수
    //    //✅
    //    @Published var capturedROIImages: [UIImage] = []   // 여러 장 누적 저장
    //    @Published var capturedTexts: [String] = []        // OCR 누적
    
    // 카메라 세션
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()//photoOutput: 실제 사진 촬영 담당
    private let sessionQueue = DispatchQueue(label: "camera.session.queue") // 세션 제어 전용 백그라운드 만들기
    
    var previewLayer: AVCaptureVideoPreviewLayer? // 프리뷰 레이어
    
    // ROIOverlay에서 계산한 ROI (previewLayer 좌표계)
    fileprivate var roiLayerRect: CGRect = .zero
    
    //디버그
    private func logROIContext(_ tag: String) {
        print("\n===== [ROI DEBUG] \(tag) =====")
        if let layer = previewLayer {
            print("layer.bounds:", layer.bounds)
            print("layer.videoGravity:", layer.videoGravity.rawValue)
            print("layer.contentsScale:", layer.contentsScale)
        } else {
            print("layer: nil")
        }
        print("roiLayerRect:", roiLayerRect)
        print("=============================\n")
    }
    
    // MARK: - Session 설정
    func startSession() {
        sessionQueue.async { //세션 제어용 전용 큐 백그라운드에서
            if self.session.isRunning { return }//중복 실행 방지
            
            self.session.beginConfiguration() // 카메라 설정 시작
            
            self.session.sessionPreset = .photo //사진 촬영 최적화 프리셋
            
            // 카메라 디바이스
            guard
                // 후면 카메라 가져오기
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, //후면 카메라 사용 디버그
                                                     for: .video,
                                                     position: .back),
                let input = try? AVCaptureDeviceInput(device: device),
                // 카메라를 세션 입력으로 연결
                self.session.canAddInput(input)
            else {
                print("❌ Camera input error")
                return
            }
            
            self.session.addInput(input) //인풋 확인 디버그
            
            guard self.session.canAddOutput(self.photoOutput) else { //사진 찍기 전용 출력
                print("❌ Photo output error")
                return
            }
            
            self.session.addOutput(self.photoOutput) //카메라&사진 연결 파이프
            
            self.session.commitConfiguration() //설정 완료
            self.session.startRunning() // 카메라 켜짐
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
        if roiLayerRect != .zero, previewLayer != nil { //로그 찍을지 판단 (좌표 디버깅)
            logROIContext("updateROIRect")
        }
    }
    
    func sendToServer(imageData: Data) {
        let locationDTO = capturedLocation?.toDTO()
        
        Task {
            try await uploadService.uploadLocation(
                //                imageData: imageData,
                //                recognizedText: recognizedText,
                location: locationDTO
            )
        }
    }
    
    func debugPrintLocation() {
        if let location = capturedLocation {
            print("📍 latitude:", location.coordinate.latitude)
            print("📍 longitude:", location.coordinate.longitude)
        } else {
            print("❌ location is nil")
        }
    }
    
    func debugPrintLocationDTO() {
        guard let dto = capturedLocation?.toDTO() else {
            print("❌ LocationDTO is nil")
            return
        }
        
        print("📦 LocationDTO")
        print(" - latitude:", dto.latitude)
        print(" - longitude:", dto.longitude)
    }
    
    func sendLocationToServer() {
        guard let locationDTO = capturedLocation?.toDTO() else {
            print("❌ locationDTO is nil")
            return
        }
        
        Task {
            do {
                try await uploadService.uploadLocation(location: locationDTO)
                print("✅ location upload success")
            } catch {
                print("🚨 location upload failed:", error)
            }
        }
    }
    
    // MARK: - 사진 촬영
    func capturePhoto() {
        sessionQueue.async { //촬영 전용 큐
            guard self.session.isRunning else { return }
            
            let settings = AVCapturePhotoSettings() //기본 카메라 세팅
            
            if let conn = self.photoOutput.connection(with: .video) {
                if conn.isVideoOrientationSupported {
                    conn.videoOrientation = .portrait
                } else if conn.isVideoRotationAngleSupported(90) {
                    conn.videoRotationAngle = 90
                }
            }
            
            Task { @MainActor in //촬영
                self.isProcessing = true //촬영 + OCR 처리
                //self.locationService.start()
                
                // 촬영 순간에 previewLayer.bounds 기준으로 ROI를 강제 계산
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
                } else {
                    print("❌ previewLayer is nil at capture")
                }
                
                // 로그 찍기
                self.logROIContext("capturePhoto: before capture")
                
            }
            
            //실제 촬영 후 delegate로 결과 받기
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
} //final class
    
    
    // MARK: - AVCapturePhotoCaptureDelegate
    extension CameraManager: AVCapturePhotoCaptureDelegate { //촬영 결과 delegate로 받아오기
        
        /// Delegate는 메인 액터 밖에서 호출될 수 있어서 nonisolated로 둠
        nonisolated func photoOutput(_ output: AVCapturePhotoOutput,
                                     didFinishProcessingPhoto photo: AVCapturePhoto,
                                     error: Error?) {
            
            if let error {
                print("❌ Capture error:", error)
                return
            }
            
            guard let data = photo.fileDataRepresentation() else { return } //이미지 데이터로 변환
            
            // MainActor에서 UIKit 작업 처리
            Task { @MainActor in
                guard let rawImage = UIImage(data: data) else { //이미지 데이터
                    self.isProcessing = false
                    return
                }
                
                // 여기서 정규화
                let image = rawImage.normalizedUp() // 이미지 다시 그려서 .up 기준으로 정렬
                
                guard let cgImage = image.cgImage else { //픽셀 배열 이미지 (width x height)
                    self.isProcessing = false
                    return
                }
                
                self.capturedLocation = self.locationService.currentLocation
                self.debugPrintLocation()
                self.debugPrintLocationDTO()
                self.sendLocationToServer()
                
                let layer = self.previewLayer
                let roi = self.roiLayerRect //촬영 순간 ROI 고정
                
                guard let layer else {
                    self.isProcessing = false
                    return
                }
                
                Task.detached { [layer, roi] in
                    let cropped = CameraManager.cropToROI( //ROI 기준으로 이미지 크롭
                        cgImage: cgImage,
                        previewLayer: layer,
                        roiLayerRect: roi
                    )
                    
                    let text = CameraManager.performOCR( //OCR 수행
                        cgImage: cgImage,
                        previewLayer: layer,
                        roiLayerRect: roi
                    )
                    
                    await MainActor.run {
                        //ROI 박스랑 같은 사이즈로 리사이즈
                        let s = layer.contentsScale   // 보통 2.0 / 3.0
                        let targetSize = CGSize(
                            width: roi.width * s,
                            height: roi.height * s
                        )
                        
                        //                            //✅ 멀티샷: "마지막 1장" + "누적 저장" 둘 다 처리
                        //                            if let cropped {
                        //                                let resized = cropped.resized(to: targetSize)
                        //                                self.croppedROIImage = resized              // 마지막 1장 미리보기
                        //                                self.capturedROIImages.append(resized)      // 누적 저장
                        //                            }
                        //
                        //                            self.recognizedText = text                    // 마지막 OCR
                        //                            if !text.isEmpty {
                        //                                self.capturedTexts.append(text)           // OCR 누적
                        //                            }
                        
                        self.croppedROIImage = cropped?.resized(to: targetSize) // 리사이즈 적용
                        self.recognizedText = text
                        self.isProcessing = false
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - OCR (Vision)
    extension CameraManager { //MainActor와 분리된 OCR 함수 (Task.detached에서 안전하게 호출 가능)
        nonisolated
        static func videoRectInLayer(bounds: CGRect, imageSize: CGSize) -> CGRect {
            let layerW = bounds.width
            let layerH = bounds.height
            
            let imageAspect = imageSize.width / imageSize.height
            let layerAspect = layerW / layerH
            
            if imageAspect > layerAspect {
                // 영상이 더 넓음 → 높이에 맞춰 채우면 좌우가 잘림
                let videoH = layerH
                let videoW = videoH * imageAspect
                let x = (layerW - videoW) / 2
                return CGRect(x: x, y: 0, width: videoW, height: videoH)
            } else {
                // 영상이 더 길쭉함 → 너비에 맞춰 채우면 상하가 잘림
                let videoW = layerW
                let videoH = videoW / imageAspect
                let y = (layerH - videoH) / 2
                return CGRect(x: 0, y: y, width: videoW, height: videoH)
            }
        }
        
        nonisolated
        static func normalizedRectFromLayerRect(
            _ layerRect: CGRect,
            layerBounds: CGRect,
            imageSize: CGSize
        ) -> CGRect {
            let videoRect = videoRectInLayer(bounds: layerBounds, imageSize: imageSize)
            
            let nx = (layerRect.minX - videoRect.minX) / videoRect.width
            let ny = (layerRect.minY - videoRect.minY) / videoRect.height
            let nw = layerRect.width / videoRect.width
            let nh = layerRect.height / videoRect.height
            
            func clamp(_ v: CGFloat) -> CGFloat { min(max(v, 0), 1) }
            
            let x = clamp(nx)
            let y = clamp(ny)
            
            // nx/ny가 음수면 width/height도 같이 줄여서 clamp되게 보정
            let w = clamp(nw + min(0, nx))
            let h = clamp(nh + min(0, ny))
            
            return CGRect(x: x, y: y, width: w, height: h)
        }
        
        nonisolated
        static func performOCR( // ROI 영역만 텍스트 인식해서 String 반환
            cgImage: CGImage, //원본 픽셀 이미지
            previewLayer: AVCaptureVideoPreviewLayer, //프리뷰 레이어
            roiLayerRect: CGRect //ROI 좌표계
        ) -> String {
            
            let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
            
            // 직접 계산한 카메라 정규화 좌표 ROI (top-left)
            let normROI = normalizedRectFromLayerRect(
                roiLayerRect,
                layerBounds: previewLayer.bounds,
                imageSize: imageSize
            )
            
            // Vision은 origin이 bottom-left라 y 뒤집기
            let visionROI = CGRect(
                x: normROI.origin.x,
                y: 1 - normROI.origin.y - normROI.height,
                width: normROI.width,
                height: normROI.height
            )
            
            let request = VNRecognizeTextRequest() //텍스트 인식 요청 객체
            request.recognitionLevel = .accurate //인식 정확도
            request.regionOfInterest = visionROI //ROI 상자만
            request.usesLanguageCorrection = true //후보정
            request.recognitionLanguages = ["ko-KR", "en-US"] //언어 설정
            request.automaticallyDetectsLanguage = false //자동언어감지 오프
            
            
            // Vision 요청 실행기
            let handler = VNImageRequestHandler(
                cgImage: cgImage,
                orientation: .up,
                options: [:]
            )
            
            //OCR 실행
            do {
                try handler.perform([request])
            } catch {
                return "❌ Vision error: \(error.localizedDescription)"
            }
            
            //결과 꺼내기
            let results = request.results as? [VNRecognizedTextObservation] ?? []
            
            //결과 문자열로 합치기
            return results
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            
        }
        
        nonisolated
        static func cropToROI( //ROI 영역만 잘라서 UIImage 반환
            cgImage: CGImage,
            previewLayer: AVCaptureVideoPreviewLayer,
            roiLayerRect: CGRect
        ) -> UIImage? {
            
            //원본 이미지 픽셀 크기 가져오기
            let W = CGFloat(cgImage.width)
            let H = CGFloat(cgImage.height)
            let imageSize = CGSize(width: W, height: H)
            
            // 직접 계산한 정규화 ROI (top-left)
            let normROI = normalizedRectFromLayerRect(
                roiLayerRect,
                layerBounds: previewLayer.bounds,
                imageSize: imageSize
            )
            
            // 픽셀 rect로 변환 (y 뒤집기)
            var rect = CGRect(
                x: normROI.origin.x * W,
                y: (1 - normROI.origin.y - normROI.height) * H,
                width: normROI.width * W,
                height: normROI.height * H
            ).integral
            
            print("normROI:", normROI)
            print("pixelRect:", rect)
            print("layer.bounds:", previewLayer.bounds)
            print("cgImage:", cgImage.width, "x", cgImage.height)
            
            //이미지 경계 밖으로 나간거 잘라내기
            rect = rect.intersection(CGRect(x: 0, y: 0, width: W, height: H))
            guard !rect.isNull, rect.width > 1, rect.height > 1 else { return nil }
            
            //크롭 수행
            guard let croppedCG = cgImage.cropping(to: rect) else { return nil }
            //UIImage로 반환
            return UIImage(cgImage: croppedCG)
            
        }
        
    }
    
    extension UIImage {
        // imageOrientation(메타)를 픽셀에 반영해서 실제로 .up인 이미지로 만들어줌
        func normalizedUp() -> UIImage {
            if imageOrientation == .up { return self } //방향 .up으로
            
            let format = UIGraphicsImageRendererFormat.default()
            format.scale = 1   // 해상도를 원본 픽셀 기준으로 처리(1pt = 1px)
            
            return UIGraphicsImageRenderer(size: size, format: format).image { _ in
                draw(in: CGRect(origin: .zero, size: size)) //픽셀 자체로 회전된 상태로 다시 그리기
            }
        }
        func resized(to targetSize: CGSize) -> UIImage { //사진 리사이즈
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
    }
