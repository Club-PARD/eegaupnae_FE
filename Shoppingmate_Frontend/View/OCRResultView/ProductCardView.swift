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
                    let side = geo.size.width

                    if let urlString = product.imageURL,
                       let url = URL(string: urlString) {

                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(Color(red: 0.91, green: 0.91, blue: 0.91))
                                    .overlay(ProgressView())
                                    .frame(width: side, height: side)

                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: side, height: side)
//                                    .clipped()
                                    .background(
                                        RoundedRectangle(cornerRadius: 9) 
                                            .fill(Color(red: 0.91, green: 0.91, blue: 0.91))
                                    )

                            case .failure:
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(Color(red: 0.91, green: 0.91, blue: 0.91))
                                    .overlay(Image(systemName: "photo").font(.system(size: 24)))
                                    .frame(width: side, height: side)

                            @unknown default:
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(Color(red: 0.91, green: 0.91, blue: 0.91))
                                    .frame(width: side, height: side)
                            }
                        }

                    } else {
                        RoundedRectangle(cornerRadius: 9)
                            .fill(Color(red: 0.91, green: 0.91, blue: 0.91))
                            .overlay(Image(systemName: "photo").font(.system(size: 24)))
                            .frame(width: side, height: side)
                    }
                }
                .aspectRatio(1, contentMode: .fit) // 정사각형 유지
       
                Text(product.perUse)
                    .font(
                        Font.custom("Pretendard-Bold", size: 11)
                    )
                        .foregroundStyle(
                                LinearGradient(
                                    stops: [
                                        .init(color: Color(red: 0.65, green: 0.32, blue: 0.91), location: 0.00),
                                        .init(color: Color(red: 0.19, green: 0.53, blue: 1.00), location: 0.53),
                                        .init(color: Color(red: 0.04, green: 0.83, blue: 0.73), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: -0.01, y: 0.49),
                                    endPoint: UnitPoint(x: 1.00, y: 0.49)
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
                                        stops: [
                                        Gradient.Stop(color: Color(red: 0.65, green: 0.32, blue: 0.91), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.19, green: 0.53, blue: 1), location: 0.53),
                                        Gradient.Stop(color: Color(red: 0.04, green: 0.83, blue: 0.73), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: -0.01, y: 0.49),
                                        endPoint: UnitPoint(x: 1, y: 0.49)
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
                
                Text(product.name)
                    .font(.custom("Pretendard-Regular", size: 12))
                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    .frame(width: 165, alignment: .topLeading)
                
                Divider()
                
                HStack {
                    Text("마트 판매가")
                      .font(.custom("Pretendard-Bold", size: 10))
                      .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    Spacer()
                        let price = product.price.digitsInt
                         Text(price.map { "\($0.formatted(.number))원" } ?? "-")
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
                    let price = product.onlinePrice.digitsInt
                    Text(price.map { "\($0.formatted(.number))원" } ?? "-")
                    //                    if let price = Int(product.onlinePrice) {
                    //                        Text("\(price.formatted(.number))원")
                        .font(.custom("Pretendard-Bold", size: 18))
                            .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                            .padding(.leading, 5)
                            .padding(.bottom, 2)
//                    }
                }
            } // VStack text
        } // VStack all
    }
}

extension String {
    var digitsInt: Int? {
        let digits = self.filter { $0.isNumber }
        return Int(digits)
    }
}
