//
//  LocationBottomSheet.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/5/26.
//

import SwiftUI

struct LocationBottomSheet: View {

    let address: String// 현재 선택된 주소
    let onCurrentLocationTap: () -> Void// "다른 위치" 눌렀을 때
    let onConfirmTap: () -> Void// "이 위치가 맞아요" 눌렀을 때

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 드래그 핸들
            HStack {
                Spacer()
                Capsule()
                    .frame(width: 48, height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                Spacer()
            }
            // 주소 영역
            VStack(alignment: .leading, spacing: 6) {
                Text("현재 위치")
                    .font(Font.custom("Arial", size: 14))
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.51))
                Text(address)
                  .font(
                    Font.custom("Arial", size: 22)
                      .weight(.bold)
                  )
                  .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                Text("여기 현재 주소 불러와야됨")
                    .font(Font.custom("Arial", size: 15))
                    .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.4))
            }
            .padding(.vertical, 23)
            
            HStack {
                HStack(alignment: .center, spacing: 0) {
                    Button {
                        onCurrentLocationTap()
                    } label: {
                        Text("다른 위치")
                          .font(
                            Font.custom("Arial", size: 16)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.4))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 13)
                .frame(height: 52, alignment: .center)
                .background(Color(red: 0.95, green: 0.96, blue: 0.96))
                .cornerRadius(14)
                
                HStack(alignment: .center, spacing: 0) {
                    Button {
                        onConfirmTap()
                    } label: {
                        Text("이 위치가 맞아요")
                          .font(
                            Font.custom("Arial", size: 16)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 55)
                .padding(.vertical, 13)
                .frame(width: 221, height: 52, alignment: .center)
                .background(Color(red: 0.25, green: 0.28, blue: 0.61))
                .cornerRadius(14)

            }
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

#Preview {
    LocationBottomSheet(
        address: "하나로마트 양덕점",
        onCurrentLocationTap: {
            print("현재 위치")
        },
        onConfirmTap: {
            print("확정")
        }
    )
}
