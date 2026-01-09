//
//  ImageCard.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/9/26.
//

import SwiftUI

struct ImageCard: View {
    let imageUrl: String

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(height: 360)

            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 360)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                    )

            case .failure:
                Image(systemName: "photo")
                    .frame(height: 360)

            @unknown default:
                EmptyView()
            }
        }
    }
}
//
//#Preview {
//    ImageCard()
//}
