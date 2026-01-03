//
//  Shoppingmate_FrontendApp.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/23/25.
//

import SwiftUI

@main
struct Shoppingmate_FrontendApp: App {
    
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environmentObject(appState)
        }
    }
}
