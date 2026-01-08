//
//  Maincard.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/8/26.
//

import SwiftUI

struct Maincard: View {
    
    let product: RecognizedProduct
    private var detail: DetailData {
        MockDetailStore.detail(for: product)
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Text(detail.title)
                    .font(
                        Font.custom("Arial-BoldMT", size: 24)
                    )
                    .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.16))
                Spacer()
            }//상품명
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.95, green: 0.95, blue: 1.0))
            )
            .padding(.horizontal, 16)
            Divider()
            HStack {
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
                Text("Ai 픽스코어")
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
                StarRatingView(rating: detail.rating)
                Text(String(format: "%.1f", detail.rating))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }//vstack

    }
}


//    // ✅ 가격 비교 카드
//    VStack(alignment: .leading, spacing: 10) {
//        PriceRow(title: "📍 픽 제품 가격 (Pick Price)", price: detail.pickPrice, isEmphasis: true)
//        PriceRow(title: "마트 판매가", price: detail.martPrice, isEmphasis: false)
//        PriceRow(title: "온라인가", price: detail.onlinePrice, isEmphasis: false)
//    }
//    .padding(14)
//    .background(Color.white)
//    .clipShape(RoundedRectangle(cornerRadius: 14))
//    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
//    
//    // ✅ SALE 배너
//    if let banner = detail.saleBannerText, !banner.isEmpty {
//        HStack(alignment: .top, spacing: 10) {
//            Text("SALE")
//                .font(.system(size: 12, weight: .bold))
//                .foregroundStyle(.white)
//                .padding(.horizontal, 10)
//                .padding(.vertical, 6)
//                .background(Color.red)
//                .clipShape(RoundedRectangle(cornerRadius: 8))
//            
//            Text(banner)
//                .font(.system(size: 13, weight: .semibold))
//                .foregroundStyle(.white)
//                .fixedSize(horizontal: false, vertical: true)
//            
//            Spacer(minLength: 0)
//        }
//        .padding(14)
//        .background(Color.red.opacity(0.85))
//        .clipShape(RoundedRectangle(cornerRadius: 14))
//    }

//#Preview {
//    Maincard(product: product)
//}
