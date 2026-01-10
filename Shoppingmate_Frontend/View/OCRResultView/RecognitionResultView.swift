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

//    let products: [RecognizedProduct]
    let userId: Int?
    @State private var products: [RecognizedProduct]
    
    init(products: [RecognizedProduct], userId: Int?) {
          self.userId = userId
          _products = State(initialValue: products)
      }
    
    private let columns = [ //2행 정렬
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    

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
                            BottomRoundedRectangle(radius: 9)
                                .fill(Color(red: 0.89, green: 0.9, blue: 1))
                                .frame(width: 349, height: 61)
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
        .onChange(of: scenePhase) { _, phase in
            if phase == .inactive || phase == .background {
                  // ✅ 나가기 직전에 화면 데이터 즉시 제거 (중요)
                  products.removeAll()
                  return
              }
            
                  guard phase == .active else { return }
            Task {
                   try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
                   await refreshFromServerAndCloseIfEmpty()
               }
              }
        .task {
            await refreshFromServerAndCloseIfEmpty()
        }

    }
    @MainActor
       private func refreshFromServerAndCloseIfEmpty() async {
           guard let userId else { return }

           do {
               let scanList = try await ScanService.shared.fetchScans(userId: userId)
               let visible = scanList.filter { $0.isShown }
               
               print("🔎 [RESULT REFRESH] total:", scanList.count, "visible:", visible.count)


               let mapped: [RecognizedProduct] = visible.map { scan in
                   RecognizedProduct(
                       image: nil,
                       badge: "",
                       brand: scan.naverBrand ?? "",
                       name: scan.scanName,
                       amount: "",
                       price: "\(scan.scanPrice)원",
                       onlinePrice: scan.naverPrice.map { "\($0)원" } ?? "-",
                       perUse: scan.aiUnitPrice ?? "분석 중...",
                       imageURL: scan.naverImage,
                       scanId: scan.scanId
                   )
               }

               self.products = mapped

               // ✅ 숨김 처리되어 남은 게 없으면 결과 화면 닫기
               if mapped.isEmpty {
                   dismiss()
               }
           } catch {
               print("❌ [RESULT REFRESH] 실패:", error.localizedDescription)
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
