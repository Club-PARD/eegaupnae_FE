//
//  SelectViewModel.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/31/25.
//

import Foundation
import CoreLocation
import Combine

final class SelectViewModel: ObservableObject {

    private let locationService = LocationService()

    /// 일반 사용자 선택 시 호출
    func selectNormalUser() {
        print("🟢 일반 사용자 선택됨")

        let status = locationService.authorizationStatus

        switch status {
        case .notDetermined:
            print("🟡 권한 요청")
            locationService.requestPermission()

        case .authorizedWhenInUse, .authorizedAlways:
            print("🟢 위치 업데이트 시작")
            locationService.start()

        case .denied, .restricted:
            print("❌ 위치 권한 거부됨")

        @unknown default:
            break
        }
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
