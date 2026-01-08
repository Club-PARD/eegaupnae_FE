//
//  ProductCardView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/2/26.
//

import SwiftUI

// 픽단가 페이지 components
struct ProductCardView: View {
    let product: RecognizedProduct

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .bottomLeading) {
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
                
                Text(product.perUse)
                        .font(Font.custom("Arial-BoldMT", size: 11))
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
                        .padding(.horizontal, 6)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
//                        .padding(.top, 6)
//                        .padding(.leading, 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                            //.inset(by: 0.65)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.65, green: 0.32, blue: 0.91),
                                            Color(red: 0.19, green: 0.53, blue: 1)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                lineWidth: 1.3)

                        )
                        .padding(.horizontal, 6)
                        .padding(.vertical, 6)
                
                
                
            } // ZStack badge

            VStack(alignment: .leading, spacing: 4) {
                Text(product.brand)
                    .font(.custom("Pretendard-Regular", size: 11))
                    .foregroundColor(Color(red: 0.59, green: 0.59, blue: 0.59))
                    .padding(.leading, 5)
                
                
                Text(product.name)
                    .font(.custom("Pretendard-Regular", size: 12))
                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    .frame(width: 165, alignment: .topLeading)
                    .padding(.leading, 5)
                Divider()
//                HStack(alignment: .center, spacing: 1) {
                HStack {
                    Text("마트 판매가")
                      .font(.custom("Pretendard-Bold", size: 10))
                      .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    Spacer()
                    Text(product.price)
                        .font(.custom("Pretendard-Bold", size: 18))
                        .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                        .padding(.leading, 5)
                        .padding(.bottom, 2)
                }
                HStack {
                    Text("온라인 최저가")
                        .font(.custom("Pretendard-Bold", size: 10))
                        .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    Spacer()
                    Text(product.onlinePrice)
                        .font(.custom("Pretendard-Bold", size: 18))
                        .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                        .padding(.leading, 5)
                        .padding(.bottom, 2)
                }
//                }
            } // VStack text
        } // VStack all
    }
}
