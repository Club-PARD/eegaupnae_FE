//
//  LocationInfo.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/5/26.
//

import CoreLocation

//최종선택된 위치정보
struct LocationInfo {
    let coordinate: CLLocationCoordinate2D//지도에서 확정된 좌표
    let address: String//Reverse Geocoding으로 얻은 주소
}
