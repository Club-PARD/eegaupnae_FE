//
//  ProductCardView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/2/26.
//

import SwiftUI

struct ProductCardView: View {
    let product: RecognizedProduct

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
//            Spacer().frame(height: 64)
            
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
                            .clipped() // 넘치는 부분 잘라냄
                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                            .overlay {
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(.yellow, lineWidth: 3) // ROI 테두리 느낌
//                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8.68)
                                    .fill(Color(red: 0.95, green: 0.96, blue: 0.96))
                                          
                            )
                    }
                    
                }
                .aspectRatio(1, contentMode: .fit) // 정사각형 박스 유지
//                .frame(height: 100) // 카드 이미지 높이 고정
                
                    
                    if let badge = product.badge {
                        Text(badge)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(product.brand)
                    .font(
                        Font.custom("Arial", size: 11)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.51))
                    .padding(.leading, 5)
                
                
                Text(product.name)
                    .font(Font.custom("Arial", size: 11))
                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    .frame(width: 165, alignment: .topLeading)
                    .padding(.leading, 5)
                
                Text(product.amount)
                    .font(Font.custom("Arial", size: 11))
                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    .padding(.leading, 5)
                    .frame(width: 165, alignment: .topLeading)
                
                HStack(alignment: .center, spacing: 1) {
                    Text(product.price)
                        .font(
                            Font.custom("Arial", size: 18)
                                .weight(.bold)
                        )
                        .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                        .padding(.leading, 5)
                        .padding(.trailing,3.47)
                    
                    Text(product.perUse)
                        .font(Font.custom("Arial", size: 11))
                        .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.4))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.95, green: 0.96, blue: 0.96)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                        )
                }
            }
        }
    }
}
