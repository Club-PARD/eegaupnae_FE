//
//  UploadService.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/29/25.
//

import Foundation// 네트워크, JSON, 비동기 처리 등

final class UploadService {
    
    //사용자 좌표 POST
    func uploadLocation(
        //        imageData: Data,
        //        recognizedText: String,
        location: LocationDTO?
    ) async throws {
        // URL 생성
        let baseURL = BaseURL.base.rawValue
        guard let url = URL(string: "\(baseURL)/users/location") else {
            throw URLError(.badURL)
        }
        
        // LocationDTO → JSON
        let jsonData = try JSONEncoder().encode(location)
        
        // URLRequest 설정
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 네트워크 요청
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // 응답 검증
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
    //UUID POST
    func uploadUUID(
        uuid: UUIDDTO?
    ) async throws {
        // URL 생성
        let baseURL = BaseURL.base.rawValue
        guard let url = URL(string: "\(baseURL)/users/login") else {
            throw URLError(.badURL)
        }
        
        // UUIDDTO → JSON
        let jsonData = try JSONEncoder().encode(uuid)
        
        // URLRequest 설정
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 네트워크 요청
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // 응답 검증
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}



//#Preview {
//    UploadService()
//}
