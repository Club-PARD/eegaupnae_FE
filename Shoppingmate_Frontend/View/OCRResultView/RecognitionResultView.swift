//
//  RecognitionResultView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/1/26.
//

import SwiftUI

struct RecognitionResultView: View {
    
    @Environment(\.dismiss) private var dismiss // 커스텀 뒤로가기
    let products: [RecognizedProduct]
    
    private let columns = [ //2행 정렬
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    private var productCountText: String {
        "\(products.count)개 상품"
    }
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20.29) {
                    ForEach(products) { product in
                        NavigationLink {
                                    DetailView(product: product)
                                } label: {
                                    ProductCardView(product: product)
                                }
                                .buttonStyle(.plain)
//                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal, 21)
                .padding(.top, 76)
            } //ScrollView
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing:3){
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.black)
                        }
                        Text("픽 제품")
                            .font(.custom("Arial-BoldMT", size: 16))
                    }
                }
            } //.toolbar
            .safeAreaInset(edge: .top) { // 툴바 경계선
                Divider()
            }
//        Spacer()
    }
}
