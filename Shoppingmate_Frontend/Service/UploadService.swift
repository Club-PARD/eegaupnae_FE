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
        //imageData: Data,
        //recognizedText: String,
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
    
    //마트정보 POST
    func uploadPartner(
        name: String,
        address: String,
        brn: String,
        file: URL
    ) async throws {
        
        let baseURL = BaseURL.base.rawValue
        guard let url = URL(string: "\(baseURL)/partners/apply") else {
            throw URLError(.badURL)
        }
        
        //boundary 생성(multipart의 핵심)
        //multipart는 데이터 덩어리들을 구분하는 선이 필요함. boundary = '이 줄부터 다음 파트야'라는 구분자
        //UUID 사용하면 절대 안겹침
        let boundary = UUID().uuidString
        
        // request 설정
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //"multipart 데이터 보낼거라고 알려줌" 이 줄 없으면 서버가 파일 못읽음
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        
        // multipart body 생성(서버로 보낼 모든 데이터들을 하나로 담을 박스)
        var body = Data()
        
        // text field 추가 함수(name, address, brn 문자데이터)
        func appendField(_ name: String, _ value: String) {
            body.append("--\(boundary)\r\n") //새로운 데이터 파트 시작한다는 뜻
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")//이 파트의 이름(name)을 서버에 알려줌
            body.append("\(value)\r\n")//실제값(ex. 상호명)
        }
        
        // 파일 field 추가 함수(파일 자체를 body에 넣는 함수)
        func appendFile(name: String, fileURL: URL) throws {
            guard fileURL.startAccessingSecurityScopedResource() else {
                throw URLError(.noPermissionsToReadFile)
            }
            defer {
                fileURL.stopAccessingSecurityScopedResource()
            }
            
            let filename = fileURL.lastPathComponent//파일 이름 추출
            let data = try Data(contentsOf: fileURL)//파일을 binary data로 읽기
            let mimeType = "application/octet-stream" // 파일타입(서버에서 보통 처리)
            
            body.append("--\(boundary)\r\n")//파일 파트 시작
            body.append(
                "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n"
            )//이 파트는 파일. 서버에서 key="file"
            body.append("Content-Type: \(mimeType)\r\n\r\n")//파일타입정보
            body.append(data)//파일내용
            body.append("\r\n")//줄바꿈
        }
        
        // 실제 데이터 추가
        appendField("name", name)
        appendField("address", address)
        appendField("brn", brn)
        try appendFile(name: "file", fileURL: file)
        
        // boundary 종료(데이터 끝났다는 뜻)
        body.append("--\(boundary)--\r\n")
        
        //지금까지 만든 데이터 박스를 요청에 실어줌
        request.httpBody = body
        
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
