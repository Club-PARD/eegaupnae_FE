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
                    .foregroundStyle(.blue)
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

struct BulletList: View { // 분석 문장
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items.indices, id: \.self) { i in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                    Text(items[i])
                        .font(.system(size: 13))
                        .foregroundStyle(.black.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

struct NumberedList: View { // 정보 문장
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items.indices, id: \.self) { i in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(i + 1).")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.black.opacity(0.85))
                    Text(items[i])
                        .font(.system(size: 13))
                        .foregroundStyle(.black.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
