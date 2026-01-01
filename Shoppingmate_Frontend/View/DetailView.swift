//
//  DetailView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/1/26.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.white)
                    .frame(width: 402, height: 61)
                HStack {
                    Image("bArrow")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("피죤 실내건조 섬유유연제 라벤더향")
                      .font(
                        Font.custom("Arial", size: 15)
                          .weight(.bold)
                      )
                      .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    Spacer()
                }//HStack
                .padding(20)
            }//상단 바 ZStack
            .padding(.bottom, 20)
            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)

            .shadow(color: .black.opacity(0.1), radius: 1.5, x: 0, y: 1)
            ZStack {
                //제품 사진
            }//사진 뜨는 영역 Zstack
            .frame(maxWidth: .infinity, minHeight: 288, maxHeight: 288)
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading) {
                    Text("피죤 실내건조 섬유유연제 라벤더향")
                      .font(
                        Font.custom("Arial", size: 22)
                          .weight(.bold)
                      )
                      .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                    HStack(alignment: .bottom) {
                        Text("12,575")//일단 임시가격
                          .font(
                            Font.custom("Arial", size: 30)
                              .weight(.bold)
                          )
                          .foregroundColor(Color(red: 0.04, green: 0.04, blue: 0.04))
                        Text("원")
                          .font(Font.custom("Arial", size: 14))
                          .foregroundColor(Color(red: 0.04, green: 0.04, blue: 0.04))
                    }//가격
                    .padding(.top, 3)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .overlay(
              Rectangle()
                .inset(by: 4)
                .stroke(Color(red: 0.94, green: 0.94, blue: 0.94), lineWidth: 8)
            )
        }//VStack
    }
}

#Preview {
    DetailView()
}
