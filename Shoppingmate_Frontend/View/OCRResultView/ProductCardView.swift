//
//  ProductCardView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/2/26.
//

import SwiftUI

struct ProductCardView: View {
    let product: RecognizedProduct

    var body: some View { //레전드 조정 완료
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if let image = product.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: geo.size.width, //사진 박스 크기
                                height: geo.size.width
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(Color(red: 0.91, green: 0.91, blue: 0.91))
                            )
                    }
                }
                .aspectRatio(1, contentMode: .fit) // 정사각형 박스 유지
                
//                    if let badge = product.badge {
//                        Text(badge)
//                            .font(.custom("Arial-BoldMT", size: 9.5))
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 5)
//                            .padding(.vertical, 3)
//                            .background(Color(red: 0.28, green: 0.11, blue: 0.96))
//                            .clipShape(RoundedRectangle(cornerRadius: 6))
//                            .padding(.top, 6)
//                            .padding(.leading, 6)
//                    }
                
            } // ZStack badge

            VStack(alignment: .leading, spacing: 4) {
                Text(product.brand)
                    .font(.custom("Arial", size: 11))
                    .foregroundColor(Color(red: 0.59, green: 0.59, blue: 0.59))
                    .padding(.leading, 5)
                
                
                Text(product.name)
                    .font(Font.custom("Arial", size: 11))
                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    .frame(width: 165, alignment: .topLeading)
                    .padding(.leading, 5)
                
//                HStack(alignment: .center, spacing: 1) {
                    Text(product.price)
                        .font(.custom("Arial-BoldMT", size: 18))
                        .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                        .padding(.leading, 5)
                        .padding(.bottom, 2)
                
                    Text(product.perUse)
                        .font(Font.custom("Arial-BoldMT", size: 11))
                        .foregroundColor(.white)
                        .padding(.horizontal, 3)
                        .padding(.vertical, 2)
                        .background(Color(red: 0.93, green: 0.39, blue: 0.34))
                        .cornerRadius(4)
                        .padding(.leading, 5)
//                }
            } // VStack text
        } // VStack all
    }
}
