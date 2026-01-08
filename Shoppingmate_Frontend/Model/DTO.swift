//
//  LocationDTO.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/29/25.
//

import CoreLocation
import Foundation

//DTO 파일에는 struct/extension만 있어야 함

struct UUIDDTO: Codable {
    let uuid: String
}

struct UserIdResponse: Codable {
    let userId: Int
}

// DTO: Data Transfer Object
struct LocationDTO: Codable {
    let userId: Int
    let latitude: Double
    let longitude: Double
}

struct ScanUploadRequest: Codable {
    let userId: Int
    let items: [ScanUploadItem]
}

struct ScanUploadItem: Codable {
    let scanName: String
    let scanPrice: Int
}

struct ScanItemResponse: Codable, Identifiable {
    let userId: Int
    let scanId: Int
    let scanName: String
    let scanPrice: Int
    let naverPrice: Int?
    let naverBrand: String?
    let naverMaker: String?      // 서버에 있을 수 있으니 포함 (안 오면 무시)
    let naverImage: String?
    let aiUnitPrice: String?

    var id: Int { scanId }
}

// Apple이 만든 CLLocation type에 새 기능 추가
// CLLocation 상속은 불가, 확장만 가능
extension CLLocation {
    func toDTO(userId: Int) -> LocationDTO {// CLLocation -> LocationDTO로 변환하는 함수
        LocationDTO(
            userId: userId,
            latitude: self.coordinate.latitude,// 현재 위치 객체의 위도 값을 꺼내서 DTO에 넣는다
            longitude: self.coordinate.longitude
        )
    }
}
