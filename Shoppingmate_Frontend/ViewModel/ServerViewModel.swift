//
//  ServerViewModel.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/6/26.
//

import SwiftUI
import CoreLocation
import Combine

final class ServerViewModel: NSObject, ObservableObject {
    
    @Published var isUserReady: Bool = false
    private let loginViewModel: LoginViewModel
    private let uploadService = UploadService()
    private let locationService = LocationService()
    private var capturedLocation: CLLocation?
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    
//    func sendToServer(imageData: Data) {
//        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
//        
//        let locationDTO = capturedLocation?.toDTO(userId: userId)
//        
//        Task {
//            try await uploadService.uploadLocation(
//                //                imageData: imageData,
//                //                recognizedText: recognizedText,
//                location: locationDTO
//            )
//        }
//    }
    
    func debugPrintLocation() {
        if let location = capturedLocation {
            print("📍 latitude:", location.coordinate.latitude)
            print("📍 longitude:", location.coordinate.longitude)
        } else {
            print("❌ location is nil")
        }
    }
    
    func debugPrintLocationDTO(_ dto: LocationDTO) {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        guard let dto = capturedLocation?.toDTO(userId: userId) else {
            print("❌ LocationDTO is nil")
            return
        }
        
        print("📦 LocationDTO")
        print(" - latitude:", dto.latitude)
        print(" - longitude:", dto.longitude)
    }
    
//    func sendLocationToServer() {
//        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
//        
//        guard let locationDTO = capturedLocation?.toDTO(userId: userId) else {
//            print("❌ locationDTO is nil")
//            return
//        }
//        
//        Task {
//            do {
//                try await uploadService.uploadLocation(location: locationDTO)
//                print("✅ location upload success")
//            } catch {
//                print("🚨 location upload failed:", error)
//            }
//        }
//    }
    
//    func handleLocationAfterLogin() {
//        Task {
//            // 위치가 아직 없으면 잠깐 대기 (최대 1초 정도)
//            for _ in 0..<10 {
//                if locationService.currentLocation != nil {
//                    break
//                }
//                try await Task.sleep(nanoseconds: 100_000_000) // 0.1초
//            }
//
//            // 위치 가져오기
//            guard let location = locationService.currentLocation else {
//                print("❌ 위치를 가져오지 못함")
//                return
//            }
//
//            self.capturedLocation = location
//
//            // 디버그 로그
//            self.debugPrintLocation()
//            self.debugPrintLocationDTO()
//
//            // 서버 전송
//            //self.sendLocationToServer()
//        }
//    }
    
    func handleLocationAfterLogin() {
        Task {
            // userId 준비될 때까지 대기 (최대 2초)
            var userId: Int = 0
            for _ in 0..<20 {
                userId = UserDefaults.standard.integer(forKey: "userId")
                if userId != 0 {
                    break
                }
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1초
            }

            guard userId != 0 else {
                print("❌ userId 끝까지 준비 안 됨")
                return
            }

            print("✅ userId 준비 완료:", userId)

            // 위치가 아직 없으면 잠깐 대기 (최대 1초)
            for _ in 0..<10 {
                if locationService.currentLocation != nil {
                    break
                }
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1초
            }

            // 위치 가져오기
            guard let location = locationService.currentLocation else {
                print("❌ 위치를 가져오지 못함")
                return
            }

            self.capturedLocation = location

            // 디버그 로그 (기존 그대로)
            self.debugPrintLocation()

            let locationDTO = location.toDTO(userId: userId)
            self.debugPrintLocationDTO(locationDTO)

            // 서버 전송 (PATCH)
            do {
                try await uploadService.updateLocation(location: locationDTO)
                print("✅ 로그인 후 위치 서버 전송 성공")
            } catch {
                print("❌ 로그인 후 위치 서버 전송 실패:", error)
            }
        }
    }
    
    func handleLocationUpdateAfterButton() {
        Task {
            // userId 준비됐는지 먼저 확인
            guard isUserReady else {
                print("⏳ userId 아직 준비 안 됨, 위치 업데이트 보류")
                return
            }
            // 위치 들어올 때까지 잠깐 대기
            for _ in 0..<10 {
                if locationService.currentLocation != nil {
                    break
                }
                try await Task.sleep(nanoseconds: 100_000_000)
            }

            guard let location = locationService.currentLocation else {
                print("❌ 위치를 가져오지 못함 (UPDATE)")
                return
            }

            let userId = UserDefaults.standard.integer(forKey: "userId")
            guard userId != 0 else {
                        print("❌ userId 없음")
                        return
                    }
            
            let dto = location.toDTO(userId: userId)

            do {
                try await uploadService.updateLocation(location: dto)
                print("🔄 위치 UPDATE 성공")
            } catch {
                print("❌ 위치 UPDATE 실패:", error)
            }
        }
    }
}



//self.capturedLocation = self.locationService.currentLocation
//self.debugPrintLocation()
//self.debugPrintLocationDTO()
//self.sendLocationToServer()
