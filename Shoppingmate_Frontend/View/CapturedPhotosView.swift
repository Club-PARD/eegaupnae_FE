//
//  CapturedPhotosView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/31/25.
//

import SwiftUI
import UIKit

struct CapturedPhotosView: View {
    let images: [UIImage]

    private let cols = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: cols, spacing: 12) {
                ForEach(images.indices, id: \.self) { i in
                    Image(uiImage: images[i])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("촬영한 사진 \(images.count)장")
    }
}
