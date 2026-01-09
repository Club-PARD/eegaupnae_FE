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
            Text(detail.conclusion.removingDoubleAsterisks)
                .font(.custom("Pretendard-Bold", size: 20))
                .foregroundColor(
                    detail.conclusion.contains("보류")
                    ? Color(red: 0.90, green: 0.30, blue: 0.35)
                    : Color(red: 0.25, green: 0.28, blue: 0.61)
                )
        }
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        )
        .padding(.horizontal, 16)
    }
}
//
//#Preview {
//    PurchaseHoldCard()
//}
