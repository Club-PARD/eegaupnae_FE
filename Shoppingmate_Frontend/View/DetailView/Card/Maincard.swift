//
//  Maincard.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/8/26.
//

import SwiftUI

struct Maincard: View {
    
    let detail: DetailResponse
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Text(detail.scanName)
                    .font(
                        Font.custom("Pretendard-Bold", size: 24)
                    )
                    .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.16))
                Spacer()
            } //상품명
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .padding(.top, 10)
//            .background(
//                RoundedRectangle(cornerRadius: 16)
//                    .fill(Color(red: 0.95, green: 0.95, blue: 1.0))
//            )
            .padding(.horizontal, 16)
            Divider()
                .padding(.horizontal, 30)
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
                Spacer()
                StarRatingView(rating: detail.pickScore ?? 0)
                Text(String(format: "%.1f", detail.pickScore ?? 0))
                    .font(.custom("Pretendard-Bold", size: 35))
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
            }
            .padding(.horizontal, 30)
            HStack {
                Text("마트 판매가")
                    .font(.custom("Pretendard-Regular", size: 16))
                  .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                Spacer()
                Text("\(detail.scanPrice)")
                    .font(.custom("Pretendard-Bold", size: 24))
                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    .padding(.leading, 5)
                    .padding(.bottom, 2)
            }
            .padding(.horizontal, 30)
            HStack {
                Text("온라인 최저가")
                    .font(.custom("Pretendard-Regular", size: 16))
                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                Spacer()
                Text("\(detail.naverPrice)")
                    .font(.custom("Pretendard-Bold", size: 24))
                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    .padding(.leading, 5)
                    .padding(.bottom, 2)
            }
            .padding(.horizontal, 30)
        } //vstack

    }
}


#Preview {
    Maincard(
        detail: DetailResponse(
            naverImage: "https://example.com/image.jpg",
            scanName: "아리엘 액체세제 2L",
            pickScore: 4.5,
            scanPrice: 9800,
            naverPrice: 12800,
            priceDiff: -3000,
            isCheaper: true,
            conclusion: "구매 추천",
            qualitySummary: "세정력이 뛰어나요",
            priceSummary: "온라인보다 저렴해요",
            category: "생활용품",
            indexes: []
        )
    )
}

