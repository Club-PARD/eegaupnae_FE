//
//  LocationService.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/29/25.
//

import Foundation//기본 타입/기능(날짜, 문자열 등) 사용
import CoreLocation
import Combine

// final: 상속을 막아서(성능/안전) 이 클래스는 여기서 끝
// NSObject: CLLocationManagerDelegate를 쓰기 위해 필요(Obj-C 런타임 기반 delegate)
// ObservableObject: SwiftUI가 상태 변화를 감지하도록 해줌(@Published를 View가 자동 반영)
final class LocationService: NSObject, ObservableObject {

    // CLLocationManager: iOS 위치 서비스를 실제로 제어하는 "핵심 매니저"
    private let locationManager = CLLocationManager()

    // @Published: 값이 바뀌면 SwiftUI View가 자동으로 다시 그려짐(리렌더)
    // currentLocation: 최신 위치(좌표)를 저장해 SwiftUI/VM에서 접근할 수 있게 함
    @Published var currentLocation: CLLocation?

    // authorizationStatus: 현재 위치 권한 상태(허용/거부/미결정 등)를 저장
    @Published var authorizationStatus: CLAuthorizationStatus

    // init(): LocationService가 만들어질 때 1번 실행되는 초기화 함수
    override init() {
        // locationManager.authorizationStatus: 현재 권한 상태를 읽어옴
        // (처음 실행 시 보통 .notDetermined일 가능성이 큼)
        self.authorizationStatus = locationManager.authorizationStatus

        // super.init(): NSObject 초기화(상위 클래스 초기화) 반드시 호출
        super.init()

        // delegate 연결: 위치 업데이트/권한 변경 같은 이벤트를 이 클래스가 받도록 설정
        locationManager.delegate = self

        // desiredAccuracy: 위치 정확도 설정(정확할수록 배터리 더 사용)
        // HundredMeters: 대략 100m 단위(가격표/매장 단위 기록이면 보통 충분)
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    // MARK: - Permission (권한 요청 관련)

    // requestPermission(): "앱 사용 중 위치 권한" 팝업을 띄우는 요청
    // (Info.plist에 NSLocationWhenInUseUsageDescription 없으면 앱 크래시)
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - Location (위치 업데이트 관련)

    // start(): 위치 업데이트를 시작
    // (위치가 갱신되면 delegate의 didUpdateLocations가 호출됨)
    func start() {
        locationManager.startUpdatingLocation()
    }

    // stop(): 위치 업데이트를 중지(배터리 절약)
    // "한 번만 좌표 필요"할 때 꼭 stop 해주는 게 좋아
//    func stop() {
//        locationManager.stopUpdatingLocation()
//    }
}

// extension으로 delegate 구현을 분리하면 코드가 깔끔해짐
extension LocationService: CLLocationManagerDelegate {

    // didUpdateLocations: 위치가 업데이트될 때마다 시스템이 호출해주는 콜백(핵심)
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let loc = locations.last else { return }

                currentLocation = loc
                print("📍 위도:", loc.coordinate.latitude)
                print("📍 경도:", loc.coordinate.longitude)

        manager.stopUpdatingLocation()
    }
    // locationManagerDidChangeAuthorization: 권한 상태가 바뀔 때 호출
    // (허용/거부/미결정 → 허용 감지)
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        // 최신 권한 상태를 @Published에 반영해서
        // SwiftUI가 "권한 바뀜"을 감지하도록 함
        authorizationStatus = manager.authorizationStatus
        print("🔑 권한 상태 변경:", authorizationStatus)
        
//        if authorizationStatus == .authorizedWhenInUse ||
//               authorizationStatus == .authorizedAlways {
//                manager.startUpdatingLocation()
//            }
    }

    // (선택) 에러 발생 시 호출되는 콜백도 구현 가능
    // 위치 서비스를 못 쓰는 상황(권한 거부, 시스템 오류 등)에서 유용
//    func locationManager(
//        _ manager: CLLocationManager,
//        didFailWithError error: Error
//    ) {
//        // 에러 로그 출력(디버깅용)
//        print("Location error:", error.localizedDescription)
//    }
}

//#Preview {
//    LocationService()
//}
