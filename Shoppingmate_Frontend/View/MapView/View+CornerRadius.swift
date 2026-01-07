//
//  View+CornerRadius.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/7/26.
//

import SwiftUI
//
//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(
//            roundedRect: rect,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//        return Path(path.cgPath)
//    }
//}
//
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(RoundedCorner(radius: radius, corners: corners))
//    }
//}
struct TopRoundedRectangle: Shape {
    var radius: CGFloat = 20

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight], // 👈 위쪽만
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
