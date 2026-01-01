//
//  SelectView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/30/25.
//

import SwiftUI

struct SelectView: View {
    private var viewModel = SelectViewModel()
    var body: some View {
        ZStack {
            Color(red:249/255, green: 250/255, blue: 251/255)
                .ignoresSafeArea(edges: .all)
            VStack {
                HStack {
                    VStack(alignment:.leading) {
                        Text("어떤 분이신가요?")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .padding(.bottom, 3)
                        Text("서비스 이용 목적을 선택해주세요.")
                            .foregroundColor(Color(red:106/255, green: 114/255, blue: 130/255))
                            .font(.system(size: 15))
                            .fontWeight(.regular)
                    }
                    .padding()
                    Spacer()
                }
                VStack {
                    //일반 사용자 버튼
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.white)
                            .frame(width: 362, height: 95)
                            .overlay(//테두리
                                RoundedRectangle(cornerRadius: 13)
                                    .stroke(
                                        Color.black.opacity(0.1),
                                        lineWidth: 1
                                    )
                            )
                        HStack {
                            Image("Person")
                                .resizable()
                                .frame(width: 50, height: 50)
                            VStack(alignment:.leading) {
                                Text("일반 사용자")
                                    .font(.system(size: 17))
                                    .fontWeight(.bold)
                                    .padding(.bottom, 1)
                                Text("마트에서 똑똑하게 쇼핑하고 싶어요.")
                                    .foregroundColor(Color(red:106/255, green: 114/255, blue: 130/255))
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                            .padding(10)
                            Spacer()
                        }
                        .padding(.horizontal, 50)
                    }
                    .onTapGesture {
                        viewModel.selectNormalUser()
                        
                    }
                    .padding(.bottom, 10)
                    //제휴 파트너 버튼
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.white)
                            .frame(width: 362, height: 95)
                            .overlay(//테두리
                                RoundedRectangle(cornerRadius: 13)
                                    .stroke(
                                        Color.black.opacity(0.1),
                                        lineWidth: 1
                                    )
                            )
                        HStack {
                            Image("Store")
                                .resizable()
                                .frame(width: 50, height: 50)
                            VStack(alignment:.leading) {
                                Text("제휴 파트너")
                                    .font(.system(size: 17))
                                    .fontWeight(.bold)
                                    .padding(.bottom, 1)
                                Text("우리 마트를 홍보하고 싶어요.")
                                    .foregroundColor(Color(red:106/255, green: 114/255, blue: 130/255))
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                            .padding(10)
                            Spacer()
                        }
                        .padding(.horizontal, 50)
                    }//제휴파트너 버튼
                }//버튼 VStack
                .padding(.top, 150)
                Spacer()
            }
        }
    }
}

#Preview {
    SelectView()
}
