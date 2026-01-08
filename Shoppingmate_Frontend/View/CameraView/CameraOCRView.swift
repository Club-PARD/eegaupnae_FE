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
    
    let cameFromMap: Bool
    let userIdResponse: UserIdResponse // userID 업로드
    
    
    @State private var ParseFail = false // 파싱 실패 시 출력 문구
    @State private var ocrBeforeCount: Int = 0 // OCR 촬영 저장 확인용 (문구)
    @State private var didTapCapture = false // OCR 촬영 저장 확인용

    
    @State private var goResult = false //결과 화면 이동 여부
    @State private var goToMap = false
    
    @State private var roiOverlayID = UUID() // 애니메이션 용 UUID 관찰
    
    //업로드 UI 상태
    @State private var isUploading = false
    @State private var showUploadError = false
    @State private var uploadErrorMessage = ""
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // 카메라 프리뷰
            CameraPreview(session: camera.session) { layer in
                camera.previewLayer = layer
            }
            .ignoresSafeArea()
            //지도로 가는 버튼
            VStack {
                HStack {
                    Button {
                        if cameFromMap {
                            dismiss()              // 로그인 → 지도 → 카메라
                        } else {
                            goToMap = true         // 로그인 안 거친 경우
                        }
                    } label: {
                        Image("goMap")
                            .resizable()
                            .frame(width: 130, height: 40)
                            .padding(5)
                    }
                    .padding(.leading, 5)
                    .padding(.top, 5)

                    Spacer()
                }
                Spacer()
            }
            .overlay(alignment: .center) {
                ROIOverlay(ParseFail: $ParseFail)
                    .id(roiOverlayID) // id 바뀌면 ROI 재생성
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 프리뷰 전체 크기 받기
                    .ignoresSafeArea()                                // 카메라 프리뷰랑 좌표 맞추기
                    .allowsHitTesting(false)
            }
            
            // 하단 버튼 구역
            VStack {
                Spacer()
                
                if camera.isProcessing { //로딩 표시
                    ProgressView("OCR 중...")
                        .padding()
                }
                if isUploading {
                    ProgressView("서버 전송 중...")
                        .padding()
                }
                
               //찍은 사진 썸네일 표시
                if !camera.capturedROIImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(camera.capturedROIImages.indices, id: \.self) { i in
                                ZStack{
                                    // 썸네일 이미지
                                    Image(uiImage: camera.capturedROIImages[i])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipped()
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            camera.deleteCaptured(at: i)
                                        }
                                }
                                .overlay(alignment: .topTrailing) {
                                    // 우측 상단 X 버튼
                                    Button {
                                        camera.deleteCaptured(at: i)
                                    } label: {
                                        Image("LegendDelete")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:21,height:21)
                                    }
                                    .offset(x: 9, y: -9)
                                }
                            }
                        }
                        .padding(.leading, 30)
                        .padding(.trailing, 16)
                        .padding(.top,10)
                    }
                    .frame(height: 70)
                    .offset(y: -30)
                }
                
                ZStack{
                    Button { //카메라 버튼
                        ocrBeforeCount = camera.OCRFilters.count
                        didTapCapture = true
                        camera.capturePhoto()
                        
                        // guard !camera.isProcessing else { return } // 연타 시 꼬임 방지
                        
//                        camera.capturePhoto() // ParseFail 안하면 이거만ㄱ
                    } label: {
                        ZStack{
                            Circle()
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            .init(color: Color(red: 0.25, green: 0.28, blue: 0.61), location: 0.0),
                                            .init(color: Color(red: 0.66, green: 0.68, blue: 1.0), location: 1.0)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 4)
                                .shadow(color: .black.opacity(0.1), radius: 7.5, x: 0, y: 10)
                                .overlay(
                                    Circle()
                                        .inset(by: 2)
                                        .stroke(.white, lineWidth: 4)
                                )
                            Circle()
                                .fill(Color.white)
                                .frame(width: 64, height: 64)
                        }
                    }
                        // .disabled(camera.isProcessing) //연타 시 꼬임 방지
                        // .opacity(camera.isProcessing ? 0.6 : 1.0) //(선택) 비활성 시 시각 피드백
                    
                    HStack(alignment: .center) { //check button
                        Spacer()
                        Button { //사진 이동 체크 버튼
                                //   guard !camera.isProcessing else { return } //연타 시 꼬임 방지
                                //   guard !camera.capturedROIImages.isEmpty else { return }
                                //   goResult = true
                            
//                            if !camera.capturedROIImages.isEmpty {
//                                goResult = true
//                            }
                            
                            print("✅ 체크 버튼 눌림")
                            Text("filters:\(camera.OCRFilters.count) proc:\(camera.isProcessing ? "T":"F") up:\(isUploading ? "T":"F")")
                                .font(.caption2)
                                .foregroundStyle(.white)

                            
                            
                            Task { await uploadAndGoResult() }
                            
                        } label: {
                            Image("Check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26, height: 26)
                                .padding(11)
                                .background(
                                      camera.capturedROIImages.isEmpty
                                      ? Color(red: 0.4, green: 0.4, blue: 0.4)
                                      : Color(red: 0.25, green: 0.28, blue: 0.61)
                                  )
                                .clipShape(Circle())
                        }
                            // .disabled(camera.capturedROIImages.isEmpty || camera.isProcessing) // 연타 시 꼬임 방지
                            // .opacity((camera.capturedROIImages.isEmpty || camera.isProcessing) ? 0.6 : 1.0)
                        
//                        .disabled(camera.OCRFilters.isEmpty) // OCRFilter 값 없으면 비활성
                        
//                        .disabled(camera.capturedROIImages.isEmpty) // ROI 이미지 없으면 비활성
//                          .disabled(camera.OCRFilters.isEmpty || camera.isProcessing || isUploading)
                        .disabled(false)
                        
                        .padding(.trailing, 20) // 우측 여백
                        
                    } //HStack 체크 버튼
                } // ZStack buttons
                .padding(.bottom, 33) // bottom safearea 34pt
                
            } // VStack 하단 버튼 구역
            
            
//            // 결과 표시 (OCR인식 확인용)
//            if !camera.recognizedText.isEmpty {
//                VStack {
//                    Spacer()
//                    Text(camera.recognizedText)
//                        .padding()
//                        .background(.ultraThinMaterial)
//                        .cornerRadius(12)
//                        .padding()
//                }
//            }
            
            // 결과 표시 (OCR Filter 적용)
            if !camera.OCRFilters.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("📦 Captured Items")
                        .font(.headline)

                    ForEach(camera.OCRFilters) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("상품명: \(item.name)")
                                .font(.subheadline)

                            Text("가격: \(String(item.price))원")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            
            
        } //ZStack all
        .onChange(of: camera.isProcessing) { isProcessing in //파싱 시 안내 문구 출력
            // processing이 끝나는 순간만 체크
            guard didTapCapture, isProcessing == false else { return }
            didTapCapture = false
            // 촬영 전후 count가 같으면 "추가가 안 된 것" → 실패 문구
            if camera.OCRFilters.count == ocrBeforeCount {
                handleParseFail()
            }
        }

        .navigationDestination(isPresented: $goResult) {
            RecognitionResultView(
                products: makeProducts(from: camera.capturedROIImages)
            )
        }
        .navigationDestination(isPresented: $goToMap) {
            LocationSelectView(userIdResponse: userIdResponse)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            camera.startSession()
            roiOverlayID = UUID() // 카메라 페이지 들어올 때마다 애니메이션 다시
        }

        //        .onDisappear { camera.stopSession() } //뒤로 갈 때 카메라 깜빡임 있어서 일단 꺼둠
    } // var body
    
    private func makeProducts(from images: [UIImage]) -> [RecognizedProduct] {
        images.map { image in
            RecognizedProduct(
                image: image,
                brand: "피죤",
                name: "피죤 실내건조 섬유유연제 라벤더향",
                amount: "2.5L",
                price: "12,800원",
                onlinePrice: "15,000원",
                perUse: "한번 사용 283원꼴"
            )
        }
    }
    
   private func handleParseFail() { // 파싱 실패 시 문구
       guard ParseFail == false else { return }
        ParseFail = true

        // 1초 후 fade out
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                ParseFail = false
            }
        }
    }

    @MainActor
    private func uploadAndGoResult() async { // 서버 업로드 함수
        print("🚀 uploadAndGoResult 진입, OCRFilters:", camera.OCRFilters.count)
        guard !camera.OCRFilters.isEmpty else { return }

        isUploading = true
        defer { isUploading = false }

        let items: [ScanUploadItem] = camera.OCRFilters.map {
            ScanUploadItem(scanName: $0.name, scanPrice: $0.price)
        }

        do {
            print("📤 [SCAN] 서버 업로드 시작")
            try await ScanService.shared.uploadScans(
                userId: userIdResponse.userId,
                items: items
            )
            print("✅ 서버 업로드 성공 → goResult = true 설정 직전")
               goResult = true
               print("➡️ goResult 현재값:", goResult)
//            goResult = true
        } catch {
            print("❌ uploadAndGoResult catch:", error.localizedDescription)
            uploadErrorMessage = error.localizedDescription
            showUploadError = true
        }
    }

    
} // struct View
