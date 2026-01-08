//
//  ROIOverlay.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 12/26/25.
//

import SwiftUI

// OCR 박스 그리기
struct ROIOverlay: View {
    
    @Binding var ParseFail: Bool                // 파싱 실패 문구
    @State private var t: CGFloat = 0           // 작은 박스 애니메이션 용 (1 = 원래 ROI)
    @State private var hideImage = false        // 이미지 페이드아웃 용
    
    var body: some View {
        GeometryReader { geo in // 레이아웃 화면 크기 인식
            
            let endRect = roiRect(in: geo.size) // 'Roi' 불러오기 (최종 ROI)
            let startRect = makeStartRect(from: endRect) // UI 애니메이션용 시작 rect
            let rect = lerpRect(from: startRect, to: endRect, t: t) // 애니메이션 rect
            let imageScale: CGFloat = 0.73
            
            ZStack { // 스캔 지역 커스텀
                
                Image("pricetag")
                    .resizable()
                    .scaledToFill()
                    .frame(width: startRect.width * imageScale, height: startRect.height * imageScale)
                    .clipped()
                    .position(x: startRect.midX, y: startRect.midY)
                    .opacity(hideImage ? 0 : 1)
                    .offset(
                        x: hideImage ? 0 : 0,
                        y: hideImage ? 0 : 0
                    )
                    .animation(.easeOut(duration: 0.2), value: hideImage)
                
                Text("가격표를 찍어주세요")
                    .font(.custom("Arial-BoldMT", size: 22))
                    .foregroundColor(.white)
                    .position(
                        x: startRect.midX,
                        y: startRect.maxY + 35
                    )
                    .opacity(hideImage ? 0 : 1)
                    .offset(
                        x: hideImage ? 0 : 0,
                        y: hideImage ? 0 : 0
                    )
                    .animation(.easeOut(duration: 0.2), value: hideImage)
                
                
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
                
                if ParseFail {
                    Text("가격표를 눌러주세요")
                        .font(.custom("Arial-BoldMT", size: 22))
                        .foregroundColor(.white)
                        .position(
                            x: endRect.midX,
                            y: endRect.midY
                        )
                        .transition(.opacity)
                }
                
            } //ZStack
                     .onAppear {
                         t = 0 //뷰가 나타날 때 작은 박스
                         hideImage = false
                         DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                 withAnimation(.easeOut(duration: 0.3)) {
                                 t = 1
                                     hideImage = true
                             }
                         }
                     }
        } //GeometryReader
        .ignoresSafeArea() //프리뷰랑 화면 좌표계 맞추기
        .allowsHitTesting(false)
    }
}

struct CornerL: View {
    let length: CGFloat = 21
    let thickness: CGFloat = 10

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: length))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: length, y: 0))
        }
        .stroke(
            Color(red: 0.85, green: 0.85, blue: 0.85),
            style: StrokeStyle(lineWidth: thickness, lineCap: .butt, lineJoin: .round)
        )
        .frame(width: length, height: length)
    }
}

// 시작 작은 박스
  private func makeStartRect(from rect: CGRect) -> CGRect {
      let scale: CGFloat = 0.67
      let dy: CGFloat = 0

      let w = rect.width * scale
      let h = rect.height * scale
      let cx = rect.midX
      let cy = rect.midY + dy

      return CGRect(
          x: cx - w / 2,
          y: cy - h / 2,
          width: w,
          height: h
      )
  }

// 중간 박스
private func lerpRect(from a: CGRect, to b: CGRect, t: CGFloat) -> CGRect {
     let tt = min(1, max(0, t))
     return CGRect(
         x: a.origin.x + (b.origin.x - a.origin.x) * tt,
         y: a.origin.y + (b.origin.y - a.origin.y) * tt,
         width: a.width + (b.width - a.width) * tt,
         height: a.height + (b.height - a.height) * tt
     )
 }
