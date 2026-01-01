//
//  PartnerView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/31/25.
//

import SwiftUI

struct PartnerView: View {
    var body: some View {
        ZStack {
            Color(red:249/255, green: 250/255, blue: 251/255)
                .ignoresSafeArea(edges: .all)
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(red:186/255, green: 186/255, blue: 186/255))
                        .frame(width: 402, height: 61)
                    HStack {
                        Image("bArrow")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text("파트너 인증")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        Spacer()
                    }//HStack
                    .padding(20)
                }//상단 바 ZStack
                .padding(.bottom, 20)
                ZStack {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color.white)
                        .frame(width: 362, height: 557)
                        .overlay(//테두리
                            RoundedRectangle(cornerRadius: 13)
                                .stroke(
                                    Color.black.opacity(0.1),
                                    lineWidth: 1
                                )
                        )
                        .padding(.top, 10)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("사업자 정보 입력")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                                .padding(.bottom, 1)
                            Text("파트너 신청을 위해 정확한 정보를 입력해주세요.")
                                .font(.system(size: 15))
                                .foregroundColor(Color(red:113/255, green: 113/255, blue: 113/255))
                                .padding(.bottom, 20)
                            Text("상호명")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red:10/255, green: 10/255, blue: 10/255))
                                .padding(.top, 10)
                            TextField("예: 하나로마트 강남점", text: .constant("") )
                                .textFieldStyle(.plain)
                                .font(.system(size: 14))
                                .padding(.horizontal, 12)
                                .frame(width: 318, height: 41)
                                .background(
                                    RoundedRectangle(cornerRadius: 7.5)
                                            .fill(Color(red: 243/255, green: 243/255, blue: 245/255))
                                )
                            Text("대표자명")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red:10/255, green: 10/255, blue: 10/255))
                                .padding(.top, 10)
                            TextField("홍길동", text: .constant("") )
                                .textFieldStyle(.plain)
                                .font(.system(size: 14))
                                .padding(.horizontal, 12)
                                .frame(width: 318, height: 41)
                                .background(
                                    RoundedRectangle(cornerRadius: 7.5)
                                            .fill(Color(red: 243/255, green: 243/255, blue: 245/255))
                                )
                        Text("사업자등록번호")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red:10/255, green: 10/255, blue: 10/255))
                            .padding(.top, 10)
                        TextField("000-00-00000", text: .constant("") )
                            .textFieldStyle(.plain)
                            .font(.system(size: 14))
                            .padding(.horizontal, 12)
                            .frame(width: 318, height: 41)
                            .background(
                                RoundedRectangle(cornerRadius: 7.5)
                                        .fill(Color(red: 243/255, green: 243/255, blue: 245/255))
                            )
                            Text("증빙서류 제출(Excel, PDF)")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red:10/255, green: 10/255, blue: 10/255))
                                .padding(.top, 10)
                            ZStack {
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(Color(red:249/255, green: 250/255, blue: 251/255))
                                    .frame(width: 314, height: 116)
                                    .overlay(//테두리
                                        RoundedRectangle(cornerRadius: 13)
                                            .stroke(
                                                Color.black.opacity(0.1),
                                                lineWidth: 1.8
                                            )
                                    )
                                HStack {
                                    Spacer()
                                    VStack {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(red:153/255, green: 161/255, blue: 175/255))
                                                .padding(1)
                                        Text("클릭하여 파일 업로드")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(red:106/255, green: 114/255, blue: 130/255))
                                        Text("사업자등록증 또는 관련 서류")
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(red:153/255, green: 161/255, blue: 175/255))
                                            .padding(1)
                                    }
                                    Spacer()
                                }
                            }//증빙서류 제출 버튼
                            ZStack {
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(Color(red:69/255, green: 69/255, blue: 69/255))
                                    .frame(width: 318, height: 41)
                                    .padding(.vertical, 10)
                                Text("신청하기")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                            }
                        }//입력 목록 VStack
                        Spacer()
                    }//HStack
                    .padding(.horizontal, 40)
                }//입력란 큰 사각형 틀 ZStack
                Spacer()
            }//VStack
        }//제일 뒷배경(연회색)
    }
}

#Preview {
    PartnerView()
}
