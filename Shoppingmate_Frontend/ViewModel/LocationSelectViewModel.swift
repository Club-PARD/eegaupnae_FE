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

    @Published var address: String = "주소를 불러오는 중..."// 현재 지도 중심 좌표의 주소

    @Published var isConfirmed: Bool = false// "이 위치가 맞아요" 눌렀는지 여부

    var selectedLocation: LocationInfo?// 최종 확정된 위치 (다음 화면으로 전달)
    
    private let geocoder = CLGeocoder()// 좌표 주소 변환

    private let locationService: LocationService
    private var cancellables = Set<AnyCancellable>()

    // 초기화
    init(locationService: LocationService) {
        self.locationService = locationService

        // 최초 지도 위치 (앞에서 받아온 현재 사용자 위치로 받아오기)
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.5665,
                longitude: 126.9780
            ),
            span: MKCoordinateSpan(//얼마나 넓게 보여줄건지(줌 레벨)
                latitudeDelta: 0.005,
                longitudeDelta: 0.005
            )
        )
        bindLocation()
    }
    private func bindLocation() {
        locationService.$currentLocation
            .compactMap { $0 }// nil 제거
            .first()// 앞에서 받은 주소 최초 1번만 받기
            .sink { [weak self] location in
                guard let self else { return }
                self.region.center = location.coordinate
            }
            .store(in: &cancellables)
    }

    // BottomSheet 버튼

    // "다른 위치" 버튼(=현재 위치로 이동 버튼)
    func moveToCurrentLocation() {
        guard let loc = locationService.currentLocation else { return }

        // 지도 중심을 현재 위치로 이동
        withAnimation {
            region.center = loc.coordinate
        }

        reverseGeocode(loc.coordinate)// 이동한 좌표 기준으로 주소 갱신
    }

    // 지도 이동 감지

    // 지도를 드래그해서 중심 좌표가 바뀌었을 때 호출
    func onMapMoved() {
        reverseGeocode(region.center)
    }

    // 위치 확정: '이 위치가 맞아요' 버튼
    func confirmLocation() {

        // 현재 지도 중심 + 주소를 묶음
        selectedLocation = LocationInfo(
            coordinate: region.center,
            address: address
        )

        // NavigationStack 트리거
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
