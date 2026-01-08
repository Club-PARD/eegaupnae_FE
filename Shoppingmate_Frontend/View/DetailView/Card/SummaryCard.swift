//
//  SummaryCard.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/8/26.
//

import SwiftUI

struct SummaryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image("purpleBar")
                    .resizable()
                    .frame(width: 4, height: 16)
                Text("픽픽 요약")
                    .font(.custom("Pretendard-Bold", size: 17))
                    .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.16))
                Spacer()
            }
            .padding(.bottom, 10)
            HStack {
                Image("qualityIcon")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("품질 우수")
                    .font(.custom("Pretendard-Bold", size: 15))
                    .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.16))
            }
            Text("품질 상세 설명~~~~~~")
                .font(.custom("Pretendard-Regular", size: 14))
                .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.16))
                .padding(.leading, 25)
                .padding(.bottom, 10)
            
            Divider()
            
            HStack {
                Image("priceIcon")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("가격 아쉬움")
                    .font(.custom("Pretendard-Bold", size: 15))
                    .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.16))
            }
            .padding(.top, 10)
            Text("가격 상세 설명~~~~~~")
                .font(.custom("Pretendard-Regular", size: 14))
                .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.16))
                .padding(.leading, 25)
                .padding(.bottom, 10)
                 
            
     
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
    SummaryCard()
}
