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
    let userIdResponse: UserIdResponse? // userID 업로드
    
    init(
        cameFromMap: Bool,
        userIdResponse: UserIdResponse? = nil
    ) {
        self.cameFromMap = cameFromMap
        self.userIdResponse = userIdResponse
    }
    
    @State private var ParseFail = false // 파싱 실패 시 출력 문구
    @State private var ocrBeforeCount: Int = 0 // OCR 촬영 저장 확인용 (문구)
    @State private var didTapCapture = false // OCR 촬영 저장 확인용

    
    @State private var goResult = false //결과 화면 이동 여부
    @State private var products: [RecognizedProduct] = []   // 결과화면에 넘길 실제 서버 데이터
    @State private var goToMap = false
    
    @State private var roiOverlayID = UUID() // 애니메이션 용 UUID 관찰
    
    //업로드 UI 상태
    @State private var isUploading = false
    @State private var showUploadError = false
    @State private var uploadErrorMessage = ""
    
    //촬영 결과 보여주기
    @State private var showToast = false
    @State private var toastText = ""
    @State private var toastWorkItem: DispatchWorkItem?
    @State private var lastFilterCount = 0   // append일 때만 토스트 띄우기 용
    
    @State private var didSendHide = false // hide전용
    
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
                          .disabled(camera.OCRFilters.isEmpty || camera.isProcessing || isUploading)
                        
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
            
//            // 결과 표시 (OCR Filter 적용)
//            if !camera.OCRFilters.isEmpty {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("📦 Captured Items")
//                        .font(.headline)
//
//                    ForEach(camera.OCRFilters) { item in
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("상품명: \(item.name)")
//                                .font(.subheadline)
//
//                            Text("가격: \(String(item.price))원")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        .padding(8)
//                        .background(.ultraThinMaterial)
//                        .cornerRadius(8)
//                    }
//                }
//                .padding()
//            }
            
            // 촬영 결과 미리 보기
            if showToast {
                VStack {
                    Text(toastText)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding(.top,80)
                }
                .transition(.opacity)
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
        .onChange(of: camera.OCRFilters.count) { _, newCount in
            // 추가(append)일 때만 토스트
            guard newCount > lastFilterCount else {
                lastFilterCount = newCount
                return
            }
            lastFilterCount = newCount

            guard let last = camera.OCRFilters.last else { return }

            toastText = "상품명: \(last.name)\n가격: \(formatWon(last.price))원"

            toastWorkItem?.cancel()
            withAnimation(.easeOut(duration: 0.2)) { showToast = true }

            let work = DispatchWorkItem {
                withAnimation(.easeOut(duration: 0.5)) { showToast = false }
                toastText = ""
            }
            toastWorkItem = work
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: work)
        }


        .navigationDestination(isPresented: $goResult) {
            RecognitionResultView(
                products: products,
                userId: userIdResponse?.userId
            )
        }
        .navigationDestination(isPresented: $goToMap) {
            if let userIdResponse {
                LocationSelectView(userIdResponse: userIdResponse)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            camera.startSession()
            roiOverlayID = UUID() // 카메라 페이지 들어올 때마다 애니메이션 다시
        }



        //        .onDisappear { camera.stopSession() } //뒤로 갈 때 카메라 깜빡임 있어서 일단 꺼둠
    } // var body
    
//    private func makeProducts(from images: [UIImage]) -> [RecognizedProduct] {
//        images.map { image in
//            RecognizedProduct(
//                image: image,
//                brand: "피죤",
//                name: "피죤 실내건조 섬유유연제 라벤더향",
//                amount: "2.5L",
//                price: "12,800원",
//                onlinePrice: "15,000원",
//                perUse: "한번 사용 283원꼴"
//            )
//        }
//    }
    
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
    
    private func formatWon(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
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
            guard let userId = userIdResponse?.userId else {
                print("❌ userIdResponse 없음")
                return
            }
            print("📤 [SCAN] 서버 업로드 시작")

            // 1) POST /scan
            print("📤 [SCAN] POST 시작")
            try await ScanService.shared.uploadScans(
                userId: userId,
                items: items
            )

            // 2️⃣ GET /scan
            print("📥 [SCAN] GET 시작")
            let scanList = try await ScanService.shared.fetchScans(
                userId: userId
            )
            
            let visible = scanList.filter { $0.isShown }

            // 3) 서버 데이터를 RecognizedProduct로 변환
            self.products = visible.map { scan in
                RecognizedProduct(
                    image: nil, // 서버 URL로 그릴 거라 nil
                    badge: "",  // 필요하면 Best 가성비 같은거 서버가 주는 날 넣자
                    brand: scan.naverBrand ?? "",
                    name: scan.scanName,
                    amount: "", // 지금 6개 필드에 없음
                    price: "\(scan.scanPrice)원",
                    onlinePrice: scan.naverPrice.map { "\($0)원" } ?? "-",
                    perUse: scan.aiUnitPrice ?? "분석 중...",
                    imageURL: scan.naverImage,
                    scanId: scan.scanId
                )
            }

            print("✅ products 세팅 완료: \(self.products.count)개 → goResult 이동")
            
            camera.resetBatch()     // 이동 확정된 시점에만 OCRView 상태 비우기
            goResult = true
            print("➡️ goResult 현재값:", goResult)

        } catch {
            print("❌ uploadAndGoResult catch:", error.localizedDescription)
            uploadErrorMessage = error.localizedDescription
            showUploadError = true
        }
    }
    
//    @MainActor
//    private func hideAllScansWhenAppBackground() async {
//        guard let userId = userIdResponse?.userId else {
//            print("❌ [SCAN HIDE] userIdResponse 없음")
//            return
//        }
//
//        do {
//            print("📤 [SCAN HIDE] 앱 백그라운드 → PATCH 시작")
//            try await ScanService.shared.hideScans(userId: userId)
//            print("✅ [SCAN HIDE] PATCH 완료")
//            
//            // ✅ 여기! PATCH가 실제로 적용됐는지 GET으로 확인
//            do {
//                let scanList = try await ScanService.shared.fetchScans(userId: userId)
//                let shownCount = scanList.filter { $0.isShown }.count
//                let totalCount = scanList.count
//                print("🔎 [SCAN HIDE VERIFY] total:", totalCount, "shown:", shownCount)
//            } catch {
//                print("⚠️ [SCAN HIDE VERIFY] GET 실패:", error.localizedDescription)
//            }
//        } catch {
//            print("❌ [SCAN HIDE] PATCH 실패:", error.localizedDescription)
//        }
//    }

    @MainActor
    private func triggerHideIfNeeded(source: String, verify: Bool = true) {
        guard !didSendHide else { return }
        didSendHide = true

        guard let userId = userIdResponse?.userId else {
            print("❌ [SCAN HIDE] userIdResponse 없음 (\(source))")
            return
        }

        Task {
            // ✅ 백그라운드에서 네트워크 마무리 시간 확보
            let bgID = UIApplication.shared.beginBackgroundTask(withName: "scanHide") {
                print("⏰ [SCAN HIDE] background time expired")
            }
            defer { UIApplication.shared.endBackgroundTask(bgID) }

            do {
                print("📤 [SCAN HIDE] \(source) → PATCH 시작 (userId=\(userId))")
                try await ScanService.shared.hideScans(userId: userId)
                print("✅ [SCAN HIDE] PATCH 완료")

                // ✅ PATCH 적용 여부 확인 (원할 때만)
                if verify {
                    do {
                        let scanList = try await ScanService.shared.fetchScans(userId: userId)
                        let shownCount = scanList.filter { $0.isShown }.count
                        print("🔎 [SCAN HIDE VERIFY] total:", scanList.count, "shown:", shownCount)
                    } catch {
                        print("⚠️ [SCAN HIDE VERIFY] GET 실패:", error.localizedDescription)
                    }
                }
            } catch {
                print("❌ [SCAN HIDE] PATCH 실패:", error.localizedDescription)
            }
        }
    }


} // struct View
