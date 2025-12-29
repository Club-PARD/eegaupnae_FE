//
//  ROIOverlay.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/26/25.
//

import SwiftUI

struct ROIOverlay: View {

    let onUpdate: (CGRect) -> Void

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width * 0.8
            let height = geo.size.height * 0.2

            let rect = CGRect(
                x: (geo.size.width - width) / 2,
                y: (geo.size.height - height) / 2,
                width: width,
                height: height
            )

            // 가이드 박스
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow, lineWidth: 3)
                .frame(width: width, height: height)
                .position(x: geo.size.width / 2,
                          y: geo.size.height / 2)
                .onAppear {
                    onUpdate(rect)
                }
//                .onChange(of: geo.size) { _ in onUpdate(rect) } // ✅ 크기 바뀌면 갱신
        }
        .ignoresSafeArea()
    }
}
