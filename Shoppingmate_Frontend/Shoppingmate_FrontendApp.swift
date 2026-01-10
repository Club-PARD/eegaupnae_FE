//
//  Shoppingmate_FrontendApp.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/23/25.
//

import SwiftUI
import Combine
import UIKit

@main
struct Shoppingmate_FrontendApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var serverViewModel: ServerViewModel
//    @StateObject private var serverViewModel = ServerViewModel()
    
    @StateObject private var hideManager = ScanHideManager()

    init() {
           let loginVM = LoginViewModel()
           _loginViewModel = StateObject(wrappedValue: loginVM)
           _serverViewModel = StateObject(wrappedValue: ServerViewModel(loginViewModel: loginVM))
       }
//    init() {
//        let loginViewModel = LoginViewModel()
//        _serverViewModel = StateObject(
//            wrappedValue: ServerViewModel(loginViewModel: loginViewModel)
//        )
//        _loginViewModel = StateObject(wrappedValue: loginViewModel)
//    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                OnboardingView()
                    .environmentObject(loginViewModel)
                    .environmentObject(serverViewModel)
            }
            .onChange(of: scenePhase) { _, newPhase in
                            hideManager.handleScenePhase(newPhase)
                        }
        }
    }
}

@MainActor
final class ScanHideManager: ObservableObject {
    private var didSendHide = false

    func handleScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .active:
            didSendHide = false       // 다음번 백그라운드 때 다시 보내도록 리셋
        case .inactive:
            triggerHideIfNeeded(source: "app.scenePhase.inactive")
        case .background:
            // inactive에서 실패했을 때 대비 (선택)
            triggerHideIfNeeded(source: "app.scenePhase.background")
        @unknown default:
            break
        }
    }

    private func triggerHideIfNeeded(source: String) {
        guard !didSendHide else { return }
        didSendHide = true

        let userId = UserDefaults.standard.integer(forKey: "userId")
        guard userId != 0 else {
            print("❌ [SCAN HIDE] userId 없음 (\(source))")
            return
        }

        Task {
            let bgID = UIApplication.shared.beginBackgroundTask(withName: "scanHide") {
                print("⏰ [SCAN HIDE] background time expired")
            }
            defer { UIApplication.shared.endBackgroundTask(bgID) }

            do {
                print("📤 [SCAN HIDE] \(source) → PATCH 시작 (userId=\(userId))")
                try await ScanService.shared.hideScans(userId: userId)
                print("✅ [SCAN HIDE] \(source) 완료")
            } catch {
                print("❌ [SCAN HIDE] \(source) 실패:", error.localizedDescription)
                // 실패했으면 다음에 다시 시도 가능하게 풀어줌(선택)
                didSendHide = false
            }
        }
    }
}
