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
    @State private var didUploadUUID = false
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var serverViewModel: ServerViewModel
    private let uploadService = UploadService()
    
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
                CameraOCRView(cameFromMap: false)
            } else {
                LoginView()
            }
        }
        .onAppear {
            checkUUID()
        }
    }
    
    private func checkUUID() {
        guard let uuid = UserDefaults.standard.string(
            forKey: LoginViewModel.UserDefaultKey.uuid
        ) else {
            hasUUID = false
            print("🆕 UUID 없음 → LoginView 이동")
            return
        }

        hasUUID = true
        print("🆔 기존 UUID:", uuid)

        // 기존 UUID가 있을 때만 POST
        if !didUploadUUID {
            didUploadUUID = true

            let uuidDTO = UUIDDTO(uuid: uuid)

            Task {
                do {
                    try await uploadService.uploadUUID(uuid: uuidDTO)
                    print("✅ 기존 UUID 서버 전송 완료")

                    serverViewModel.handleLocationAfterLogin()
                } catch {
                    print("🚨 기존 UUID 서버 전송 실패:", error)
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
