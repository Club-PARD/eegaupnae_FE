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
    
    private let session: URLSession = {
         let config = URLSessionConfiguration.default
         config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
         config.urlCache = nil
         return URLSession(configuration: config)
     }()

    
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
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpStatus(httpResponse.statusCode, bodyText)
            }
            
            print("✅ uploadScans 성공")
        }catch{
            throw APIError.transport(error)
        }
    }
    
    

        // scan get
        func fetchScans(userId: Int) async throws -> [ScanItemResponse] {
            let baseURL = baseURL.base.rawValue

            guard var components = URLComponents(string: "\(baseURL)/scan") else {
                print("❌ [SCAN GET] URLComponents 생성 실패")
                throw APIError.invalidURL
            }

            components.queryItems = [
                URLQueryItem(name: "userId", value: String(userId)),
                URLQueryItem(name: "_ts", value: String(Int(Date().timeIntervalSince1970)))
            ]

            guard let url = components.url else {
                print("❌ [SCAN GET] URL 생성 실패")
                throw APIError.invalidURL
            }

            // 🔎 요청 로그
            print("❗️ [SCAN GET REQUEST]")
            print("URL:", url.absoluteString)
            print("Method: GET")

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.timeoutInterval = 60
            
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
               request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
               request.setValue("no-cache", forHTTPHeaderField: "Pragma")

            do {
                let (data, response) = try await session.data(for: request)
//                let (data, response) = try await URLSession.shared.data(for: request)

                let bodyText = String(data: data, encoding: .utf8) ?? ""
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ [SCAN GET] HTTPResponse 캐스팅 실패")
                    throw URLError(.badServerResponse)
                }

                // 🔎 응답 로그
                print("📥 [SCAN GET RESPONSE]")
                print("StatusCode:", httpResponse.statusCode)
                print("Body:", bodyText)

                guard (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.httpStatus(httpResponse.statusCode, bodyText)
                }

                let decoded = try JSONDecoder().decode([ScanItemResponse].self, from: data)
                print("✅ fetchScans 성공: \(decoded.count)개")
                return decoded

            } catch {
                throw APIError.transport(error)
            }
        }

    
    // PATCH /scan/hide?userId=1
        func hideScans(userId: Int) async throws {
            let baseURL = baseURL.base.rawValue

            guard var components = URLComponents(string: "\(baseURL)/scan/hide") else {
                print("❌ [SCAN HIDE] URLComponents 생성 실패")
                throw APIError.invalidURL
            }

            components.queryItems = [
                URLQueryItem(name: "userId", value: String(userId))
            ]

            guard let url = components.url else {
                print("❌ [SCAN HIDE] URL 생성 실패")
                throw APIError.invalidURL
            }

            // 🔎 요청 로그
            print("❗️ [SCAN HIDE REQUEST]")
            print("URL:", url.absoluteString)
            print("Method: PATCH")

            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.timeoutInterval = 60

            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                let bodyText = String(data: data, encoding: .utf8) ?? ""
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ [SCAN HIDE] HTTPResponse 캐스팅 실패")
                    throw URLError(.badServerResponse)
                }

                // 🔎 응답 로그
                print("📥 [SCAN HIDE RESPONSE]")
                print("StatusCode:", httpResponse.statusCode)
                print("Body:", bodyText)

                guard (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.httpStatus(httpResponse.statusCode, bodyText)
                }

                print("✅ hideScans 성공 (isShown=false 처리됨)")
            } catch let apiError as APIError {
                throw apiError                 // ✅ statusCode 보존
            } catch {
                throw APIError.transport(error)
            }
        }
    
}
