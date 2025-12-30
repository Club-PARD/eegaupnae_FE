//
//  MyView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/29/25.
//

import SwiftUI
import UIKit

struct MyView: View {
    let image: UIImage

    var body: some View {
            GeometryReader { geo in
                VStack(spacing:12){
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width)
                        .background(Color.black.opacity(0.05))
                    
                Text("image size: \(Int(image.size.width)) × \(Int(image.size.height))") //UIKit 좌표계 기준 크기 확인용
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("px: \(image.cgImage?.width ?? 0) × \(image.cgImage?.height ?? 0)") //실제 픽셀 해상도 확인용
                
                
                Spacer()
                
            }
            .navigationTitle("ROI 결과") //제목
            
        }
    }
}
