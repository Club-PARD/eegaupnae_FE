//
//  DetailView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/6/26.

import SwiftUI

struct DetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    let product: RecognizedProduct
    private var detail: DetailData {
        MockDetailStore.detail(for: product)
    }
    
    var body: some View {
        ZStack{
            Color(red: 0.95, green: 0.95, blue: 0.95)
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing:0) {
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
                        Text("픽스코어")
                            .font(
                                Font.custom("Pretendard-Bold", size: 20)
                            )
                        Spacer()
                    }
                }
                Divider()
                
                List{
                    Section{
                        Image("jh")
                            .resizable()
                            . listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                            .frame(width: 362, height: 360)
                            .listRowBackground(Color.clear)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                            )
                    }
                    .listSectionSpacing(13) // 이거 해야 총 18
                    
                    Section {
                        Maincard(product: product)
                            .listRowInsets(EdgeInsets())
                        SaleInfoCard()
                            .listRowSeparator(.hidden)
                    }
                    //구매 추천 or 비추천
                    Section {
                        PurchaseHoldCard()
                    }
                    //품질 및 가격 요약
                    Section {
                        SummaryCard()
                    }
                    //5대 지표 심층 분석
                    Section {
                        AnalysisCard()
                    }
                }
                .listSectionSpacing(18)
                
            } //vstack
        } // zstack all
        .navigationBarHidden(true)
    } // 바바디썸뷰
}
#Preview {
    let mockProduct = RecognizedProduct(
        image: UIImage(systemName: "photo"),
        badge: "Best 가성비",
        brand: "피죤",
        name: "피죤 실내건조 섬유유연제 라벤더향",
        amount: "2.5L",
        price: "8,800원",
        onlinePrice: "12,800원",
        perUse: "한번 사용 283원꼴"
    )

    return DetailView(product: mockProduct)
}

