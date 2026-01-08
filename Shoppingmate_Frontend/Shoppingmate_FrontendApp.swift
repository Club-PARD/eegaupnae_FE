//
//  Shoppingmate_FrontendApp.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/23/25.
//

import SwiftUI

@main
struct Shoppingmate_FrontendApp: App {
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var serverViewModel: ServerViewModel
//    @StateObject private var serverViewModel = ServerViewModel()

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
        }
    }
}
