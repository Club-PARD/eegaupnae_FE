//
//  RecognitionResultView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/1/26.
//

import SwiftUI

struct RecognitionResultView: View {

    // ✅ 부모가 닫는 방법을 결정 (sheet면 false로, navigation이면 pop 로직으로 연결)
//    @Binding var isPresented: Bool

    let products: [RecognizedProduct]
    
    private let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18)
    ]

    private var productCountText: String {
        "\(products.count)개 상품"
    }
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 26.73) {
                    ForEach(products) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal, 17.44)
                .padding(.top, 64)
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(white: 0.92), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        isPresented = false
//                    } label: {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 18, weight: .semibold))
//                            .foregroundStyle(.black)
//                    }
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
            }
        Spacer()
    }
}
