//
//  OnboardingView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/30/25.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ZStack {
            Color(red:65/255, green: 71/255, blue: 155/255)
                .ignoresSafeArea(edges: .all)
            Image("picpickLogo")
                .resizable()
                .frame(width: 121, height: 144)
        }
    }
}

#Preview {
    OnboardingView()
}
