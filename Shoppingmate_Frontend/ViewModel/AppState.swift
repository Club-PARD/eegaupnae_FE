//
//  AppState.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/3/26.
//

import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var userType: UserType? = nil
    let locationService = LocationService()
}
