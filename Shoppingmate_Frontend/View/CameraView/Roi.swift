//
//  Roi.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/8/26.
//

import CoreGraphics

// UI 박스/OCR 박스 통합 ROI
func roiRect(in size: CGSize) -> CGRect {
    let w = size.width * 0.776
    let h = size.height * 0.208
    
    let centerYRatio: CGFloat = 320.0 / 874.0   // 화면의 위에서 약 0.366 지점
    let centerY = size.height * centerYRatio    // 네모 중심 위치 (320)
    let y = centerY - (h / 2)           // 네모 topY
    
    
    return CGRect( // 그리기 시작 지점
        x: (size.width - w) / 2,
        y: y,
        width: w,
        height: h
    )
}

/// 화면 전체 Y = 874
/// 박스 Y 크기 = 182
/// 박스 중심 = 위에서 320 or 아래서 554
