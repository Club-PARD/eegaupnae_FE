//
//  ROIOverlay.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/26/25.
//

import SwiftUI

struct ROIOverlay: View {
    let onUpdate: (CGRect) -> Void //ROIRect를 그려서 CameraManager로 전달 (UI만 그리는 용도)

    var body: some View {
        GeometryReader { geo in // 레이아웃 크기/위치 정보 인식
            let rect = makeRect(in: geo.size) //ROIOverlay가 화면에서 차지하는 영역 크기

            RoundedRectangle(cornerRadius: 12) //노란박스
                .stroke(.yellow, lineWidth: 3)
                .frame(width: rect.width, height: rect.height)
                .position(x: rect.midX, y: rect.midY)
                .onAppear { onUpdate(rect) } //ROIOverlay가 화면에 나타날 때 rect를 전달
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    private func makeRect(in size: CGSize) -> CGRect {
        let w = size.width * 0.8
        let h = size.height * 0.2
        return CGRect(x: (size.width - w) / 2, //중앙배치
                      y: (size.height - h) / 2,
                      width: w,
                      height: h)
    }
}
