//
//  LoginViewModel.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/31/25.
//

import Foundation
import CoreLocation
import Combine

final class LoginViewModel: ObservableObject {
    let locationService = LocationService()
    
    //@Published var selectedUserType: UserType? = nil
    
    enum UserDefaultKey {
        static let isNormalUser = "isNormalUser"
        static let uuid = "guest_uuid"
    }
    
    //UUID 생성 함수
    private func getOrCreateUUID() -> String {
        if let uuid = UserDefaults.standard.string(forKey: UserDefaultKey.uuid) {
            return uuid
        }

        let newUUID = UUID().uuidString
        UserDefaults.standard.set(newUUID, forKey: UserDefaultKey.uuid)
        return newUUID
    }

    /// 일반 사용자 선택 시 호출
    func selectNormalUser() {

        print("🟢 일반 사용자 선택됨")
        locationService.requestOneTimeLocation()
        
        // 유저 타입 저장 (첫 페이지 재노출 방지)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.isNormalUser)
        
        // UUID 생성
        let uuid = getOrCreateUUID()
        print("🆔 UUID:", uuid)
        
        // 서버 로그인 (추후 연결)
        //loginGuest(uuid: uuid)
    }
    
    func selectPartner() {
        print("🟢 제휴 파트너 선택됨")
        UserDefaults.standard.set(false, forKey: UserDefaultKey.isNormalUser)
        
        //selectedUserType = .partner
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
