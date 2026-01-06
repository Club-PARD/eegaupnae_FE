//
//  CameraPreview.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/26/25.
//

import SwiftUI
import AVFoundation

// UIKit의 AVCaptureVideoPreviewLayer를 SwiftUI에서 그대로 쓰기 위한 어댑터 (카메라랑 화면 구현 연결)
///레이어는 그리기 담당, UIView는 이벤트, 레이아웃, 생명주기 담당(상위)
final class PreviewView: UIView { //이 UIView는 기본 레이어 대신 AVCapture...를 써라)
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self //카메라 프레임을 바로 그려주는 레이어
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer //무조건 AVCapture로 레이어 반환
    }
}

struct CameraPreview: UIViewRepresentable { //UIKit 사용 프로토콜

    let session: AVCaptureSession //카메라 세션 주입용 (관리는 CameraManager)
    let onLayerReady: (AVCaptureVideoPreviewLayer) -> Void //preview 외부로 전달 (OCR/크롭)

    func makeUIView(context: Context) -> PreviewView { //뷰 1회 호출
        let view = PreviewView()
        view.backgroundColor = .black //연결 전 검은 배경

        // previewLayer에 세션을 직접 연결
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill //화면 꽉 채움, 잘림 있음 (resizeAspect = 사진 안잘리는 대신 여백 있음)
        
//        //프리뷰 세로로 회전 고정
        if let conn = view.previewLayer.connection {
            if conn.isVideoOrientationSupported {
                conn.videoOrientation = .portrait
            } else if conn.isVideoRotationAngleSupported(90) {
                conn.videoRotationAngle = 90
            }
        }


        // CameraManager에 previewLayer 전달
        DispatchQueue.main.async {
            onLayerReady(view.previewLayer)
        }

        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) { //뷰 재사용할 경우 상태 동기화
        if uiView.previewLayer.session !== session { // session이 바뀌는 경우 대비
            uiView.previewLayer.session = session
        }
        uiView.previewLayer.frame = uiView.bounds
    }
}
