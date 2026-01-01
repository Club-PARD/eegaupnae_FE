//
//  SelectViewModel.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/31/25.
//

import Foundation
import CoreLocation

final class SelectViewModel {

    private let locationService = LocationService()

    /// 일반 사용자 선택 시 호출
    func selectNormalUser() {
        print("🟢 일반 사용자 선택됨 - 위치 요청 시작")
        locationService.start()
    }

    /// 디버그용 (선택)
    func debugPrintLocation() {
        if let location = locationService.currentLocation {
            print("📍 latitude:", location.coordinate.latitude)
            print("📍 longitude:", location.coordinate.longitude)
        } else {
            print("❌ location is nil")
        }
    }
}
