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
    
    private let locationService = LocationService()
    private var capturedLocation: CLLocation?
    private let uploadService = UploadService()
    
    func sendToServer(imageData: Data) {
        let locationDTO = capturedLocation?.toDTO()
        
        Task {
            try await uploadService.uploadLocation(
                //                imageData: imageData,
                //                recognizedText: recognizedText,
                location: locationDTO
            )
        }
    }
    
    func debugPrintLocation() {
        if let location = capturedLocation {
            print("📍 latitude:", location.coordinate.latitude)
            print("📍 longitude:", location.coordinate.longitude)
        } else {
            print("❌ location is nil")
        }
    }
    
    func debugPrintLocationDTO() {
        guard let dto = capturedLocation?.toDTO() else {
            print("❌ LocationDTO is nil")
            return
        }
        
        print("📦 LocationDTO")
        print(" - latitude:", dto.latitude)
        print(" - longitude:", dto.longitude)
    }
    
    func sendLocationToServer() {
        guard let locationDTO = capturedLocation?.toDTO() else {
            print("❌ locationDTO is nil")
            return
        }
        
        Task {
            do {
                try await uploadService.uploadLocation(location: locationDTO)
                print("✅ location upload success")
            } catch {
                print("🚨 location upload failed:", error)
            }
        }
    }
    
    func handleLocationAfterLogin() {
        Task {
            // 위치가 아직 없으면 잠깐 대기 (최대 1초 정도)
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

            // 디버그 로그
            self.debugPrintLocation()
            self.debugPrintLocationDTO()

            // 서버 전송
            self.sendLocationToServer()
        }
    }
}



//self.capturedLocation = self.locationService.currentLocation
//self.debugPrintLocation()
//self.debugPrintLocationDTO()
//self.sendLocationToServer()
