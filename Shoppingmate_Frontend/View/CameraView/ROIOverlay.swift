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
            
            ZStack {
                // 왼쪽 위
                CornerL()
                    .position(x: rect.minX, y: rect.minY)
                    .offset(x: 12, y: 12)
                
                // 오른쪽 위
                CornerL()
                    .rotationEffect(.degrees(90))
                    .position(x: rect.maxX, y: rect.minY)
                    .offset(x: -12, y: 12)
                
                // 오른쪽 아래
                CornerL()
                    .rotationEffect(.degrees(180))
                    .position(x: rect.maxX, y: rect.maxY)
                    .offset(x: -12, y: -12)
                
                // 왼쪽 아래
                CornerL()
                    .rotationEffect(.degrees(270))
                    .position(x: rect.minX, y: rect.maxY)
                    .offset(x: 12, y: -12)
            } //ZStack
        } //GeometryReader
        .ignoresSafeArea() //프리뷰랑 화면 좌표계 맞추기
        .allowsHitTesting(false)
    }
}

struct CornerL: View {
    let length: CGFloat = 24
    let thickness: CGFloat = 10

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: length))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: length, y: 0))
        }
        .stroke(
            Color(red: 0.85, green: 0.85, blue: 0.85),
            style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round)
        )
        .frame(width: length, height: length)
    }
}
