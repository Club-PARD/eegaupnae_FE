//
//  CameraOCRView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/26/25.
//

import SwiftUI

struct CameraOCRView: View {

    @StateObject private var camera = CameraManager()

    var body: some View {
        ZStack {

            // UIKit PreviewLayer 생성
            // CameraManager로 전달(좌표 변환용)
            CameraPreview(session: camera.session) { layer in
                camera.previewLayer = layer
            }
            .ignoresSafeArea()

            // ROI 계산 -> CameraManager에 전달
            ROIOverlay { rect in
                camera.updateROIRect(rect)
            }

            // 하단 컨트롤
            VStack {
                Spacer()

                if camera.isProcessing {
                    ProgressView("OCR 중...")
                        .padding()
                }

                Button {
                    camera.capturePhoto()
                } label: {
                    Circle()
                        .fill(.white)
                        .frame(width: 72, height: 72)
                        .overlay(
                            Circle().stroke(.black, lineWidth: 2)
                        )
                }
                .padding(.bottom, 30)
            }

            // 결과 표시
            if !camera.recognizedText.isEmpty {
                VStack {
                    Spacer()
                    Text(camera.recognizedText)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding()
                }
            }
        }
        .onAppear { camera.startSession() }
        .onDisappear { camera.stopSession() }
    }
}
