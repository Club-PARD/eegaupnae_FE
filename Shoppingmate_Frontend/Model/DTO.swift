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

// DTO: Data Transfer Object
struct LocationDTO: Codable {
    let userId: Int
    let latitude: Double
    let longitude: Double
}

struct UserIdResponse: Codable {
    let userId: Int
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
