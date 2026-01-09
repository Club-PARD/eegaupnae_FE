//
//  UploadService.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/29/25.
//

import Foundation// 네트워크, JSON, 비동기 처리 등

final class UploadService {
    
    //사용자 좌표 POST
//    func uploadLocation(
//        location: LocationDTO?
//    ) async throws {
//        // URL 생성
//        let baseURL = baseURL.base.rawValue
//        guard let url = URL(string: "\(baseURL)/users/location") else {
//            print("❌ URL 생성 실패")
//            throw URLError(.badURL)
//        }
//        
//        // LocationDTO → JSON
//        let jsonData = try JSONEncoder().encode(location)
//        
//        // URLRequest 설정
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        logRequest(request)
//        
//        // 네트워크 요청
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        // 응답 검증
//        guard let httpResponse = response as? HTTPURLResponse else {
//            print("❌ HTTPResponse 캐스팅 실패")
//            throw URLError(.badServerResponse)
//        }
//        print("📥 StatusCode:", httpResponse.statusCode)
//
//        if !(200...299).contains(httpResponse.statusCode) {
//            if let errorBody = String(data: data, encoding: .utf8) {
//                print("❌ Server Error Body:", errorBody)
//            }
//            throw URLError(.badServerResponse)
//        }
//
//        print("✅ uploadLocation 성공")
//    }
    
    //UUID POST
    func uploadUUID(
        uuid: UUIDDTO
    ) async throws -> UserIdResponse {
        // URL 생성
        let baseURL = baseURL.base.rawValue
        guard let url = URL(string: "\(baseURL)/user/login") else {
            print("❌ URL 생성 실패")
            throw URLError(.badURL)
        }
        
        // UUIDDTO → JSONㄱ
        let jsonData = try JSONEncoder().encode(uuid)
        
        // URLRequest 설정
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //logRequest(request)
        // 네트워크 요청
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let body = String(data: data, encoding: .utf8) {
            print("📦 UUID POST Response Body:", body)
        }
        
        // 응답 검증
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            print("❌ HTTPResponse 캐스팅 실패")
            throw URLError(.badServerResponse)
        }
        print("📥 StatusCode:", httpResponse.statusCode)

        let decoded = try JSONDecoder().decode(UserIdResponse.self, from: data)

        UserDefaults.standard.set(decoded.userId, forKey: "userId")
        //UserDefaults.standard.set(decoded.id, forKey: "userId")
        
        print("✅ uploadUUID 성공")
        return decoded
    }

    //UUID GET
    //이거 아직 호출 안함. 어디서 get할건지 정하기
//    func fetchUserInfo(uuid: String) async throws {
//        // URL 생성
//        let baseURL = baseURL.base.rawValue
//        guard let url = URL(string: "\(baseURL)/users/{uuid}") else {
//            print("❌ URL 생성 실패")
//            throw URLError(.badURL)
//        }
//        
//        // URLRequest 설정
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        logRequest(request)
//        
//        // 네트워크 요청
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        // 응답 검증
//        guard let httpResponse = response as? HTTPURLResponse else {
//            print("❌ HTTPResponse 캐스팅 실패")
//            throw URLError(.badServerResponse)
//        }
//        print("📥 StatusCode:", httpResponse.statusCode)
//
//        if !(200...299).contains(httpResponse.statusCode) {
//            if let errorBody = String(data: data, encoding: .utf8) {
//                print("❌ Server Error Body:", errorBody)
//            }
//            throw URLError(.badServerResponse)
//        }
//
//        if let body = String(data: data, encoding: .utf8) {
//            print("📦 Response Body:", body)
//        }
//
//        print("✅ fetchUserInfo 성공")
//    }
    
    //Location UPDATE
    func updateLocation(
        location: LocationDTO
    ) async throws {
        // URL 생성
        let baseURL = baseURL.base.rawValue
        guard let url = URL(string: "\(baseURL)/user/update-location") else {
            print("❌ URL 생성 실패")
            throw URLError(.badURL)
        }
        
        // LocationDTO → JSON
        let jsonData = try JSONEncoder().encode(location)
        
        // URLRequest 설정
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        logRequest(request)
        
        // 네트워크 요청
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 응답 검증
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ HTTPResponse 캐스팅 실패")
            throw URLError(.badServerResponse)
        }
        print("📥 StatusCode:", httpResponse.statusCode)

        if !(200...299).contains(httpResponse.statusCode) {
            if let errorBody = String(data: data, encoding: .utf8) {
                print("❌ Server Error Body:", errorBody)
            }
            throw URLError(.badServerResponse)
        }
        print("✅ updatedLocation 성공")
    }
}

//gemini GET
func getGemini(scanId: Int) async throws -> DetailResponse {
    // URL 생성
    let baseURL = baseURL.base.rawValue
    
    guard let url = URL(string: "\(baseURL)/gemini/\(scanId)") else {
        print("❌ URL 생성 실패")
        throw URLError(.badURL)
    }
    
    // URLRequest 설정
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    logRequest(request)
    
    // 네트워크 요청
    let (data, response) = try await URLSession.shared.data(for: request)
    
    // 응답 검증
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        print("❌ Server Error:", String(data: data, encoding: .utf8) ?? "")
        throw URLError(.badServerResponse)
    }
    
    if let body = String(data: data, encoding: .utf8) {
        print("📦 Raw JSON:", body)
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
        let decoded = try decoder.decode(DetailResponse.self, from: data)
        print("✅ get Gemini info 성공")
        return decoded
    } catch {
        print("❌ Decoding Error:", error)
        throw error
    }
}
//    if let body = String(data: data, encoding: .utf8) {
//        print("📦 Response Body:", body)
//    }
//
//    let decoded = try JSONDecoder().decode(DetailResponse.self, from: data)
//    print("✅ get Gemini info 성공")
//    return decoded


//디버깅용 로그함수
private func logRequest(_ request: URLRequest) {
    print("❗️ [REQUEST]")//이 아래부터 요청 로그라는 것 구별
    print("URL:", request.url?.absoluteString ?? "nil")//request.url: 이 요청이 가는 URL 객체(읽기 쉬운 형태로 변환)
    print("Method:", request.httpMethod ?? "nil")

    //body가 있으면 출력하고, 없으면 없음 출력
    if let body = request.httpBody,
       let bodyString = String(data: body, encoding: .utf8) {
        print("Body:", bodyString)
    } else {
        print("Body: 없음")
    }
}



//#Preview {
//    UploadService()
//}
