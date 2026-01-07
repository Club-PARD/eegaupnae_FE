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
    
    //private let currentLocationButtonView = CurrentLocationButton()

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
                .ignoresSafeArea(edges: .all)
            VStack {
                Image("bubble")
                    .resizable()
                    .frame(width: 120, height: 60)
                // 중앙 고정 핀(지도는 움직이고 핀은 고정)
                Image("mapPin")
                    .resizable()
                    .frame(width: 48, height: 56)
                    .offset(y: -18)
            }//vstack
            .padding(.bottom, 150)
        }
        .navigationBarBackButtonHidden(true)

        // BottomSheet
        .overlay(alignment: .bottom) {
            LocationBottomSheet(
                viewModel: viewModel,
                // 다른 위치
                onCurrentLocationTap: {
                    viewModel.moveToCurrentLocation()
                },
                //이 위치로 설정
                onConfirmTap: {
                    viewModel.confirmLocation()
                }
            )
        }
        .overlay(alignment: .bottomTrailing) {
            CurrentLocationButton {
                print("📌 현재 위치 버튼 눌림")
                viewModel.moveToCurrentLocation()
            }
            .padding(Edge.Set.trailing, 20)
            .padding(Edge.Set.bottom, 230) // BottomSheet 높이만큼 띄우기
        }
        // 다음 화면 이동
        .navigationDestination(
            isPresented: $viewModel.isConfirmed
        ) {
            CameraOCRView(cameFromMap: true)
        }
    }
}

#Preview {
    LocationSelectView()
}
