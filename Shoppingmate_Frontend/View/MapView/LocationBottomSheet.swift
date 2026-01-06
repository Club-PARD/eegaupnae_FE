//
//  LocationBottomSheet.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/5/26.
//

import SwiftUI

struct LocationBottomSheet: View {
    
    @ObservedObject var viewModel: LocationSelectViewModel

    //let address: String// 현재 선택된 주소
    let onCurrentLocationTap: () -> Void// "다른 위치" 눌렀을 때
    let onConfirmTap: () -> Void// "이 위치가 맞아요" 눌렀을 때

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 주소 영역
            VStack(alignment: .leading, spacing: 8) {
                Text("현재 위치")
                    .font(Font.custom("Arial", size: 14))
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.51))
                Text("(현재마트 받아오기)")
                    .font(
                        Font.custom("Arial", size: 22)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                if let address = viewModel.address {
                    Text(address)
                        .font(Font.custom("Arial", size: 15))
                        .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.4))
                } else {
                    Text("주소를 불러오는 중…")
                        .font(Font.custom("Arial", size: 15))
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 23)

            //"다른 위치" 버튼
            //                Button {
            //                    onCurrentLocationTap()
            //                } label: {
            //                    Text("다른 위치")
            //                      .font(
            //                        Font.custom("Arial", size: 16)
            //                          .weight(.bold)
            //                      )
            //                      .multilineTextAlignment(.center)
            //                      .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.4))
            //                }
            //                .padding(.horizontal, 24)
            //                .padding(.vertical, 13)
            //                .frame(height: 52, alignment: .center)
            //                .background(Color(red: 0.95, green: 0.96, blue: 0.96))
            //                .cornerRadius(14)
            
            //"이 위치로 주소 등록" 버튼
            Button {
                onConfirmTap()
            } label: {
                Text("이 위치로 설정")
                    .font(
                        Font.custom("Arial", size: 16)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 55)
            .padding(.vertical, 13)
            .frame(width: 360, height: 52, alignment: .center)
            .background(Color(red: 0.25, green: 0.28, blue: 0.61))
            .cornerRadius(14)

        }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
    }
}

//#Preview {
//    LocationBottomSheet(
//        address,
//        onCurrentLocationTap: {
//            print("현재 위치")
//        },
//        onConfirmTap: {
//            print("확정")
//        }
//    )
//}
