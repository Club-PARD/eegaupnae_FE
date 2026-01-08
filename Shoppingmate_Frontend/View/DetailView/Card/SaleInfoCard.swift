//
//  SaleInfoCard.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/8/26.
//

import SwiftUI

struct SaleInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // 🔹 상단 타이틀
            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.30, green: 0.35, blue: 0.75))
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())

                Text("3일 뒤에 할인 행사!")
                    .font(Font.custom("Pretendard-Bold", size: 18))
                    .foregroundColor(Color(red: 0.25, green: 0.28, blue: 0.61))
            }
            .padding(.top, -5)

            // 🔹 내용
            VStack(spacing: 10) {
                HStack {
                    Text("행사 때 사면")
                        .foregroundColor(Color(red: 0.35, green: 0.40, blue: 0.75))
                    Spacer()
                    Text("3,300원 더 절약")
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.30, green: 0.35, blue: 0.75))
                }

                HStack {
                    Text("온라인 최저가보다")
                        .foregroundColor(Color(red: 0.35, green: 0.40, blue: 0.75))
                    Spacer()
                    Text("900원 더 이득")
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.30, green: 0.35, blue: 0.75))
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 0.93, green: 0.94, blue: 1.0))
        )
        .padding(.horizontal, 5)
    }
}

#Preview {
//    let mockProduct = RecognizedProduct(
//        image: UIImage(systemName: "photo"),
//        badge: "Best 가성비",
//        brand: "피죤",
//        name: "퍼실 라벤더 1.5(겸용)",
//        amount: "2.5L",
//        price: "8,800원",
//        onlinePrice: "12,800원",
//        perUse: "한번 사용 283원꼴"
//    )

    SaleInfoCard()
}
