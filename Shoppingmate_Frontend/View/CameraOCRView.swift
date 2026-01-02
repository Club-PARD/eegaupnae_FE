////
////  CameraOCRView.swift
////  Shoppingmate_Frontend
////
////  Created by Jinsoo Park on 12/26/25.
////
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

                .overlay(alignment: .center) {
                    ROIOverlay()
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // 프리뷰 전체 크기 받기
                        .ignoresSafeArea()                                // 카메라 프리뷰랑 좌표 맞추기
                        .allowsHitTesting(false)
                }
                
                // 하단 버튼
                VStack {
                    Spacer()
                    
                    if camera.isProcessing {
                        ProgressView("OCR 중...")
                            .padding()
                    }
                    
//                   //✅ 찍은 사진 썸네일(스샷처럼)
//                    if !camera.capturedROIImages.isEmpty {
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 8) {
//                                ForEach(camera.capturedROIImages.indices, id: \.self) { i in
//                                    Image(uiImage: camera.capturedROIImages[i])
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 46, height: 46)
//                                        .clipped()
//                                        .cornerRadius(6)
//                                }
//                            }
//                            .padding(.horizontal, 16)
//                        }
//                        .frame(height: 56)
//                    }
                    
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
//                            //✅ 누적된 사진이 1장이라도 있으면 이동
//                            if !camera.capturedROIImages.isEmpty {
//                                goResult = true
//                            }
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
                    PhotoReviewView(image: img)
                }
            }
            
//            //✅ 체크 누르면 "누적된 이미지들"을 한 번에 보여주는 화면으로 이동
//            .navigationDestination(isPresented: $goResult) {
//                CapturedPhotosView(images: camera.capturedROIImages)
//            }
            
            .onAppear { camera.startSession() }
            .onDisappear { camera.stopSession() }
        }
    }
}
