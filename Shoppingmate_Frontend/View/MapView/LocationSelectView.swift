//
//  LocationSelectView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/5/26.
//

import SwiftUI
import MapKit

struct LocationSelectView: View {

    @StateObject private var locationService = LocationService()
    @StateObject private var viewModel: LocationSelectViewModel
    
    //private let currentLocationButtonView = currentLocationButton()

    // LocationService를 ViewModel과 공유하기 위한 init
    init() {
        let service = LocationService()

        _locationService = StateObject(wrappedValue: service)
        _viewModel = StateObject(
            wrappedValue: LocationSelectViewModel(locationService: service)
        )
    }

    var body: some View {
            ZStack {
                // Apple Map
                Map(coordinateRegion: $viewModel.region)
                    .onMapCameraChange { context in
                            viewModel.onMapMoved()// 사용자가 드래그, 줌 끝낸 시점
                        }

                // 중앙 고정 핀(지도는 움직이고 핀은 고정)
                Image("mapPin")
                    .resizable()
                    .frame(width: 48, height: 56)
                    .offset(y: -18)
//                HStack(alignment: .center, spacing: 10) {
//                    Image("currentLocation")
//                        .resizable()
//                        .frame(width: 22, height: 22)
//                }
//                .padding(12)
//                .frame(width: 46, height: 46, alignment: .leading)
//                .background(Color(red: 1, green: 1, blue: 1))
//                .cornerRadius(23)
//                .shadow(color: .black.opacity(0.25), radius: 1.5, x: 0, y: 0)
                
            }
            .onAppear {
                // 화면 뜨자마자 위치 권한/위치 요청
                locationService.startLocationIfAuthorized()
            }
            // BottomSheet
            .safeAreaInset(edge: .bottom) {
                LocationBottomSheet(
                    address: viewModel.address,
                    // 다른 위치
                    onCurrentLocationTap: {
                        viewModel.moveToCurrentLocation()
                    },
                    //이 위치가 맞아요
                    onConfirmTap: {
                        viewModel.confirmLocation()
                    }
                )
            }
//            .overlay(alignment: .bottomTrailing) {
//                currentLocationButtonView
//                    .padding(Edge.Set.trailing, 16)
//                    .padding(Edge.Set.bottom, 120) // BottomSheet 높이만큼 띄우기
//            }
            
            

            // 다음 화면 이동
            .navigationDestination(
                isPresented: $viewModel.isConfirmed
            ) {
                CameraOCRView()
            }
    }
}

#Preview {
    LocationSelectView()
}
