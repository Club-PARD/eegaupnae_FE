//
//  OnboardingView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/30/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var isFinished = false
    
    var body: some View {
        if isFinished {
            SelectView()
        } else {
            ZStack {
                Color(red: 65/255, green: 71/255, blue: 155/255)
                    .ignoresSafeArea()

                OnboardingLogoView {
                    isFinished = true
                }
                .frame(width: 420, height: 840)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
