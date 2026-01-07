//
//  BottomRoundedRectangle.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/8/26.
//

import SwiftUI

struct BottomRoundedRectangle: Shape {
    var radius: CGFloat = 16

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    BottomRoundedRectangle()
}
