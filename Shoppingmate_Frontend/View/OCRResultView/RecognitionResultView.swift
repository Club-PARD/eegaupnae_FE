//
//  RecognitionResultView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/1/26.
//

import SwiftUI
import UIKit

// 픽단가 페이지
struct RecognitionResultView: View {
    
    @Environment(\.dismiss) private var dismiss // 커스텀 뒤로가기
    @Environment(\.scenePhase) private var scenePhase
    let products: [RecognizedProduct]
    let userId: Int?
    @State private var didSendHide = false
    
    private let columns = [ //2행 정렬
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    private func triggerHideIfNeeded(source: String) {
        guard !didSendHide else { return }
        didSendHide = true
        
        guard let userId else {
            print("❌ [SCAN HIDE] userId 없음 (\(source))")
            return
        }
        
        Task {
            // 백그라운드에서 네트워크가 끊기는 것 방지(성공률↑)
            let bgID = UIApplication.shared.beginBackgroundTask(withName: "scanHide")
            defer { UIApplication.shared.endBackgroundTask(bgID) }
            
            do {
                print("📤 [SCAN HIDE] \(source) → PATCH 시작 (userId=\(userId))")
                try await ScanService.shared.hideScans(userId: userId)
                print("✅ [SCAN HIDE] PATCH 완료")
            } catch {
                print("❌ [SCAN HIDE] PATCH 실패:", error.localizedDescription)
            }
        }
    }

    private var productCountText: String {
        "\(products.count)개 상품"
    }
    
    var body: some View {
        ZStack{
            Color(red: 0.95, green: 0.95, blue: 0.95)
                .ignoresSafeArea(edges: .all)
            VStack {
                ZStack {
                    Rectangle()
                        .frame(height: 61)
                        .foregroundColor(.white)
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("backArrow")
                                .resizable()
                                .frame(width: 20, height: 24)
                                .padding(.leading, 20)
                        }
                        Text("픽단가")
                            .foregroundColor(Color.black)
                            .font(.custom("Pretendard-Bold", size: 20))
                        Spacer()
                    }
                }
                Divider()
                    .padding(.top, -12)
                HStack(spacing: 12) {
                            Image("sparkles")
                                .resizable()
                                .frame(width: 29, height: 27)
                                //.padding(.leading, 5)
                                .padding(.trailing, -10)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.45, green: 0.35, blue: 0.95),
                                            Color(red: 0.30, green: 0.75, blue: 0.95)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                               )
                            Text("Ai 픽단가")
                              .font(.custom("Pretendard-Bold", size: 17))
                              .foregroundStyle(
                                      LinearGradient(
                                          colors: [
                                              Color(red: 0.65, green: 0.32, blue: 0.91),
                                              Color(red: 0.19, green: 0.53, blue: 1)
                                          ],
                                          startPoint: .leading,
                                          endPoint: .trailing
                                      )
                                  )
                            Text("환산으로 최저가를 확인하세요")
                              .font(.custom("Pretendard-Bold", size: 17))
                              .foregroundColor(Color(red: 0.25, green: 0.28, blue: 0.61))
                              .lineLimit(1)
                              .padding(.leading, -8)
                }//hstack
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                            BottomRoundedRectangle(radius: 20)
                                .fill(Color(red: 0.89, green: 0.9, blue: 1))
                                .frame(width: 361, height: 61)
                        )
                .padding(.horizontal, 16)
                .padding(.top, -17)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(products) { product in
                            NavigationLink {
                                DetailView(scanId: product.scanId)
                            } label: {
                                ProductCardView(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 21)
                    .padding(.top, 30)
                } //ScrollView
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }
        } //zstack
        .onChange(of: scenePhase) { _, newPhase in
              guard newPhase == .background else { return }
              triggerHideIfNeeded(source: "scenePhase.background")
          }
          // ✅ 백그라운드 감지 더 확실하게(선택이지만 추천)
          .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
              triggerHideIfNeeded(source: "didEnterBackgroundNotification")
          }
    }
}

//#Preview {
//    let mockProducts: [RecognizedProduct] = [
//            RecognizedProduct(
//                image: UIImage(systemName: "photo"),
//                badge: "Best 가성비",
//                brand: "피죤",
//                name: "피죤 실내건조 섬유유연제 라벤더향",
//                amount: "2.5L",
//                price: "8,800원",
//                onlinePrice: "12,800원",
//                perUse: "한번 사용 283원꼴",
//                scanId: 12345
//            )
//    ]
//    NavigationStack {
//        RecognitionResultView(products: mockProducts)
//    }
//}
