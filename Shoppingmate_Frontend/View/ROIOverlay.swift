//
//  ROIOverlay.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/26/25.
//

import SwiftUI

//노란 박스 그리기
struct ROIOverlay: View {
    var body: some View {
        GeometryReader { geo in // 레이아웃 화면 크기 인식
            let size = geo.size
            let w = size.width * 0.8
            let h = size.height * 0.2
            let rect = CGRect(x: (size.width - w)/2, y: (size.height - h)/2, width: w, height: h) //노란 박스 그릴 UI 좌표

            RoundedRectangle(cornerRadius: 12) //노란 박스
                .stroke(.yellow, lineWidth: 3)
                .frame(width: rect.width, height: rect.height)
                .position(x: rect.midX, y: rect.midY) //중심 좌표 기준으로 위치 배치
        }
        .ignoresSafeArea() //프리뷰랑 화면 좌표계 맞추기
        .allowsHitTesting(false)
    }
}
