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
                    
                   //찍은 사진 썸네일(스샷처럼)
                    if !camera.capturedROIImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(camera.capturedROIImages.indices, id: \.self) { i in
                                    Image(uiImage: camera.capturedROIImages[i])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 46, height: 46)
                                        .clipped()
                                        .cornerRadius(6)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(height: 56)
                    }
                    
                    Button {
//                        guard !camera.isProcessing else { return } // 연타 시 꼬임 방지
                        camera.capturePhoto()
                    } label: {
                        ZStack{
                            Circle()
                                .fill(.white)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .stroke(Color(red: 0.82, green: 0.84, blue: 0.86), lineWidth: 2)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                )
                        }
                    }
//                    .disabled(camera.isProcessing) //연타 시 꼬임 방지
//                    .opacity(camera.isProcessing ? 0.6 : 1.0) //(선택) 비활성 시 시각 피드백
                    .padding(.bottom, 40)
                }
                
                //사진 이동 체크 버튼
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
//                            guard !camera.isProcessing else { return } //연타 시 꼬임 방지
//                            guard !camera.capturedROIImages.isEmpty else { return }
//                            goResult = true
                            if !camera.capturedROIImages.isEmpty {
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
//                        .disabled(camera.capturedROIImages.isEmpty || camera.isProcessing) // 연타 시 꼬임 방지
//                        .opacity((camera.capturedROIImages.isEmpty || camera.isProcessing) ? 0.6 : 1.0)
                        .disabled(camera.capturedROIImages.isEmpty) // ROI 이미지 없으면 비활성
                    }
                }
                
                // 결과 표시
//                if !camera.recognizedText.isEmpty {
//                    VStack {
//                        Spacer()
//                        Text(camera.recognizedText)
//                            .padding()
//                            .background(.ultraThinMaterial)
//                            .cornerRadius(12)
//                            .padding()
//                    }
//                }
                
            } //ZStack
            .navigationDestination(isPresented: $goResult) {
                RecognitionResultView(
                    products: makeProducts(from: camera.capturedROIImages)
                )
            }
            .onAppear { camera.startSession() }
            .onDisappear { camera.stopSession() }
        }
    }
    
    private func makeProducts(from images: [UIImage]) -> [RecognizedProduct] {
        images.map { image in
            RecognizedProduct(
                image: image,
                badge: "Best 가성비",
                brand: "피죤",
                name: "피죤 실내건조 섬유유연제 라벤더향",
                amount: "2.5L",
                price: "12,800원",
                perUse: "1회당 40원"
            )
        }
    }
}

