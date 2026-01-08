//
//  LocationSelectViewModel.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/5/26.
//

import Foundation
import MapKit
import CoreLocation
import Combine
import SwiftUI

final class LocationSelectViewModel: ObservableObject {

    // 지도 상태
    @Published var region: MKCoordinateRegion

    @Published var address: String? = nil// 현재 지도 중심 좌표의 주소

    @Published var isConfirmed: Bool = false// "이 위치가 맞아요" 눌렀는지 여부
    
    @Published private var shouldMoveToCurrentLocation = false

    var selectedLocation: LocationInfo?// 최종 확정된 위치 (다음 화면으로 전달)
    
    private let geocoder = CLGeocoder()// 좌표 주소 변환

    private let locationService: LocationService
    private var cancellables = Set<AnyCancellable>()
    @EnvironmentObject var serverViewModel: ServerViewModel

    // 초기화
    init(locationService: LocationService) {
        self.locationService = locationService

        // 최초 지도 위치 (앞에서 받아온 현재 사용자 위치로 받아오는걸로 수정해야됨)
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.5665,
                longitude: 126.9780
            ),
            span: MKCoordinateSpan(//얼마나 넓게 보여줄건지(줌 레벨)
                latitudeDelta: 0.0005,
                longitudeDelta: 0.0005
            )
        )
        bindLocation()
    }
    
    private func bindLocation() {
        locationService.$currentLocation
            .compactMap { $0 }// nil 제거
            .sink { [weak self] location in
                guard let self else { return }
                // 현재 위치 버튼을 눌렀을 때만 지도 이동
                if self.shouldMoveToCurrentLocation {
                    print("🗺️ 현재 위치로 지도 이동")
                    withAnimation {
                        self.region.center = location.coordinate
                    }
                    // 주소도 현재 위치 기준으로 갱신
                    self.reverseGeocode(location.coordinate)
                    // 1회 처리 후 리셋
                    self.shouldMoveToCurrentLocation = false
                }
            }
            .store(in: &cancellables)
    }

    // 현재 위치 버튼
    func moveToCurrentLocation() {
        print("📌 현재 위치 버튼 클릭")
        
        // 다음 위치 수신 시 지도 이동하라고 표시
        shouldMoveToCurrentLocation = true
        
        locationService.requestCurrentLocation()
        serverViewModel.handleLocationUpdateAfterButton()
    }

    // 지도 이동 감지
    // 지도를 드래그해서 중심 좌표가 바뀌었을 때 호출
    func onMapMoved() {
        reverseGeocode(region.center)
    }

    // 위치 확정: '이 위치로 설정' 버튼
    func confirmLocation() {
//        guard let address else {
//            print("❌ 주소가 아직 없습니다")
//            return
//        }
//
//        // 현재 지도 중심 + 주소를 묶음
//        selectedLocation = LocationInfo(
//            coordinate: region.center,
//            address: address
//        )

        // NavigationStack 트리거/
        isConfirmed = true
    }

    // 좌표 주소 변환
    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {

        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            guard let place = placemarks?.first else { return }

            // 주소 구성 (필요에 따라 수정 가능)
            self.address =
            [place.name, place.locality]
                .compactMap { $0 }
                .joined(separator: " ")
        }
    }
}
