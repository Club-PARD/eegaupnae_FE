//
//  CameraOCRView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/26/25.
//

import SwiftUI

struct CameraOCRView: View {

    @StateObject private var camera = CameraManager()
    @State private var goResult = false //결과 화면 이동 여부

    var body: some View {
        NavigationStack{
            ZStack {
                
                // 카메라 프리뷰
                CameraPreview(session: camera.session) { layer in
                    camera.previewLayer = layer
                }
                .ignoresSafeArea()
                
                // ROI 오버레이
                .overlay(alignment: .center) {
                    ROIOverlay { rect in
                        camera.updateROIRect(rect)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 프리뷰 전체 크기 받기
                    .ignoresSafeArea()                                 // 카메라 프리뷰랑 좌표 맞추기
                    .allowsHitTesting(false)
                }
                
                // 하단 버튼
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
                
                //사진 이동 체크 버튼
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            if camera.croppedROIImage != nil {
                                goResult = true
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.title2)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding()
                        .disabled(camera.croppedROIImage == nil) // ROI 이미지 없으면 비활성
                    }
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
            } //ZStack
            .navigationDestination(isPresented: $goResult) {
                if let img = camera.croppedROIImage { //잘린 이미지 MyView로 전달
                    MyView(image: img)
                }
            }
            .onAppear { camera.startSession() }
            .onDisappear { camera.stopSession() }
        }
    }
}
