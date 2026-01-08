//
//  DetailComponents.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/6/26.
//

import SwiftUI

struct StarRatingView: View { //별점 UI
    let rating: Double // 0~5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { idx in
                Image(systemName: idx < Int(round(rating)) ? "star.fill" : "star")
                    .font(.system(size: 12))
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
        }
    }
}

struct PriceRow: View { // 가격 표시 줄
    let title: String
    let price: String
    let isEmphasis: Bool

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.black.opacity(0.75))

            Spacer()

            Text(price)
                .font(.system(size: 16, weight: isEmphasis ? .bold : .semibold))
                .foregroundStyle(isEmphasis ? .red : .black)
        }
    }
}

struct InfoCard<Content: View>: View { // 섹션 카드 컨테이너
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.black)

            content
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}
