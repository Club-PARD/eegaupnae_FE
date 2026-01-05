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

    // LocationService를 ViewModel과 공유하기 위한 init
    init() {
        let service = LocationService()

        _locationService = StateObject(wrappedValue: service)
        _viewModel = StateObject(
            wrappedValue: LocationSelectViewModel(locationService: service)
        )
    }

    var body: some View {
        NavigationStack {
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
            
            

            // 다음 화면 이동
            .navigationDestination(
                isPresented: $viewModel.isConfirmed
            ) {
                CameraOCRView()
            }
        }
    }
}

#Preview {
    LocationSelectView()
}
