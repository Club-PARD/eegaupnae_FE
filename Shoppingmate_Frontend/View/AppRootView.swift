//
//  AppRootView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/3/26.
//

import SwiftUI

struct AppRootView: View {

    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.userType == nil {
            SelectView()
        } else if appState.userType == .normal {
            DetailView()
        } else {
            PartnerView()
        }
    }
}
#Preview {
    AppRootView()
}
