//
//  AnalysisCard.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/9/26.
//

import SwiftUI

struct AnalysisCard: View {
    
    let detail: DetailResponse
    
    private var iconNames: [String] {
       AnalysisIconProvider.icons(for: detail.category)
   }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image("purpleBar")
                    .resizable()
                    .frame(width: 4, height: 16)
                Text("5대 지표 심층 분석")
                    .font(.custom("Pretendard-Bold", size: 17))
                    .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.16))
                Spacer()
            }
            .padding(.bottom, 10)

            //5개 지표 나열
            ForEach(Array(zip(detail.indexes.indices, detail.indexes)), id: \.0) { i, item in
                
                HStack(alignment: .top, spacing: 12) {

                    Image(iconNames[safe: i] ?? "icon_default")
                        .resizable()
                        .frame(width: 48, height: 48)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text(item.reason.removingDoubleAsterisks)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
    
            
            //.listRowSeparator(.hidden)//구분선 안보이게
           
     
        }
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        )
        .padding(.horizontal, 16)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

//#Preview {
//    AnalysisCard()
//}
