//
//  ScanService.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/8/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case httpStatus(Int, String)
    case transport(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL이 올바르지 않아요."
        case .httpStatus(let code, let body):
            return "서버 오류 (HTTP \(code))\n\(body)"
        case .transport(let e):
            return "네트워크 오류: \(e.localizedDescription)"
        }
    }
}

//scan post
final class ScanService {
    static let shared = ScanService()
    
    func uploadScans(
        userId: Int,
        items: [ScanUploadItem]
    ) async throws {
        
        let baseURL = baseURL.base.rawValue
        guard let url = URL(string: "\(baseURL)/scan") else {
            print("❌ [SCAN] URL 생성 실패")
            throw APIError.invalidURL
//            print("❌ URL 생성 실패")
//            throw URLError(.badURL)
        }
        
        let body = ScanUploadRequest(userId: userId,items: items)
        let jsonData = try JSONEncoder().encode(body)
        
        // 🔎 요청 로그
              print("❗️ [SCAN REQUEST]")
              print("URL:", url.absoluteString)
              print("Method: POST")
              print("Body:", String(data: jsonData, encoding: .utf8) ?? "nil")

        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let bodyText = String(data: data, encoding: .utf8) ?? ""
            print("📦 Scan POST Response Body:", bodyText)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ HTTPResponse 캐스팅 실패")
                throw URLError(.badServerResponse)
            }
            
            // 🔎 응답 로그
                  print("📥 [SCAN RESPONSE]")
                  print("StatusCode:", httpResponse.statusCode)
                  print("Body:", bodyText)
            
//            print("📥 StatusCode:", httpResponse.statusCode)
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpStatus(httpResponse.statusCode, bodyText)
            }
            
            print("✅ uploadScans 성공")
        }catch{
            throw APIError.transport(error)
        }
    }
}
