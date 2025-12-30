//
//  UploadService.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/29/25.
//

import Foundation// 네트워크, JSON, 비동기 처리 등

final class UploadService {

    func upload(
        imageData: Data,
        recognizedText: String,
        location: LocationDTO?
    ) async throws {

        // 서버로 보낼 JSON body
        var body: [String: Any] = [
            "text": recognizedText
        ]

        // 위치가 있을 때만 JSON에 포함
        if let location {
            body["latitude"] = location.latitude
            body["longitude"] = location.longitude
        }
        
        // Swift Dictionary -> JSON Data
        let jsonData = try JSONSerialization.data(withJSONObject: body)

        // Swagger 보고 엔드포인트 다시 넣기(넣으면 ! 빼기)
        var request = URLRequest(url: URL(string: "https://your.api/upload")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 실제 네트워크 요청
        // URLSession.shared: 기본 세션
        // .data(for:):  요청 전송
        // await: 응답 올 때까지 대기
        // try: 네트워크 오류 시 throw
        let (_, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

//#Preview {
//    UploadService()
//}
