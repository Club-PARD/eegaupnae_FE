//
//  TopRoundedRect.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/9/26.
//

import SwiftUI

struct TopRoundedRect: Shape {
    var radius: CGFloat = 24

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
