//
//  OnboardingView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/30/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var isFinished = false
    @State private var hasUUID = false
    
    var body: some View {
        Group {
            if !isFinished {
                ZStack {
                    Color(red: 65/255, green: 71/255, blue: 155/255)
                        .ignoresSafeArea()
                    
                    OnboardingLogoView {
                        isFinished = true
                    }
                    .frame(width: 420, height: 840)
                }
            } else if hasUUID {
                CameraOCRView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            checkUUID()
        }
    }
    
    private func checkUUID() {
        let uuid = UserDefaults.standard.string(forKey: LoginViewModel.UserDefaultKey.uuid)
        hasUUID = (uuid != nil)
        print("🆔 기존 UUID 존재 여부:", hasUUID)
    }
}

#Preview {
    OnboardingView()
}
