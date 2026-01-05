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
                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal, 21)
                .padding(.top, 76)
            } //ScrollView
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color(white: 0.92), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("인식 결과")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(productCountText)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.black.opacity(0.55))
                }
            } //.toolbar
        Spacer()
    }
}
