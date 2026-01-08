//
//  PurchaseHoldCard.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/8/26.
//

import SwiftUI

struct PurchaseHoldCard: View {
    
    let detail: DetailResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 타이틀
            Text(detail.conclusion)
                .font(.custom("Pretendard-Bold", size: 20))
                .foregroundColor(Color(red: 0.90, green: 0.30, blue: 0.35))

            // 설명 문구
            VStack(alignment: .leading, spacing: 6) {
                Text("현재 가격 메리트가 부족합니다.")
                    .font(.custom("Pretendard-Regular", size: 15))
                    .foregroundColor(Color(red: 0.25, green: 0.28, blue: 0.33))

                (
                    Text("급하지 않다면 ")
                        .font(.custom("Pretendard-Regular", size: 15))
                        .foregroundColor(Color(red: 0.25, green: 0.28, blue: 0.33))
                    +
                    Text("온라인 구매")
                        .font(.custom("Pretendard-Bold", size: 15))
                        .foregroundColor(.black)
                        .underline()
                    +
                    Text("가 더 합리적입니다.")
                        .font(.custom("Pretendard-Regular", size: 15))
                        .foregroundColor(Color(red: 0.25, green: 0.28, blue: 0.33))
                )
            }
        }
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    PurchaseHoldCard()
}
