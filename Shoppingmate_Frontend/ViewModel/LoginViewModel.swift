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
    @Published var isUserReady: Bool = false
    
    //@EnvironmentObject var serverViewModel: ServerViewModel
    
    let locationService = LocationService()
    let uploadService = UploadService()
    
    init() {}
    
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

    /// 게스트 로그인 누를  시 호출
    func guestLogin() {
        print("🟢 게스트 로그인")
        //위치 요청
        locationService.requestOneTimeLocation()
        
        // UUID 생성
        let uuid = getOrCreateUUID()
        print("🆔 UUID:", uuid)
        
        // UUID DTO 생성
        let uuidDTO = UUIDDTO(uuid: uuid)
        
        //Task에서 서버통신
        Task {
            do {
                // 유저 타입 저장 (첫 페이지 재노출 방지)
                let response = try await uploadService.uploadUUID(uuid: uuidDTO)
                
                UserDefaults.standard.set(response.userId, forKey: "userId")
                //UUID 로그인 POST
                UserDefaults.standard.set(true, forKey: UserDefaultKey.isNormalUser)
                
                DispatchQueue.main.async {
                    self.isUserReady = true
                }
                //try await uploadService.uploadUUID(uuid: uuidDTO)
                print("✅ UUID 로그인 성공")

            } catch {
                print("🚨 guestLogin 실패:", error)
            }
        }

        // 서버 로그인 (추후 연결)
        //loginGuest(uuid: uuid)
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
