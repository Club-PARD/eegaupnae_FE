//
//  CameraPreview.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/26/25.
//

import SwiftUI
import AVFoundation

// UIView 자체의 layer를 AVCaptureVideoPreviewLayer로 사용하는 정석 구현
final class PreviewView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

struct CameraPreview: UIViewRepresentable {

    let session: AVCaptureSession
    let onLayerReady: (AVCaptureVideoPreviewLayer) -> Void

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.backgroundColor = .black

        // 🔑 previewLayer에 세션을 직접 연결 (가장 중요)
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill

        // CameraManager에 previewLayer 전달
        DispatchQueue.main.async {
            onLayerReady(view.previewLayer)
        }

        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        // session이 바뀌는 경우 대비 (거의 안 바뀜)
        if uiView.previewLayer.session !== session {
            uiView.previewLayer.session = session
        }
    }
}
