//
//  PartnerFormView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/3/26.
//

import SwiftUI

struct PartnerFormView: View {
    @State private var isAfterSubmitActive = false
    
    @State private var name = ""
    @State private var address = ""
    @State private var brn = "" //사업자등록번호
    @State private var file: URL?
    
    var body: some View {
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
                        .foregroundColor(Color(red: 0.04, green: 0.04, blue: 0.04))
                    Text("파트너 신청을 위해 정확한 정보를 입력해주세요.")
                        .font(.system(size: 15))
                        .foregroundColor(Color(red:113/255, green: 113/255, blue: 113/255))
                        .padding(.bottom, 20)
                    Text("상호명")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red:10/255, green: 10/255, blue: 10/255))
                        .padding(.top, 10)
                    TextField(
                        "",
                        text: $name,
                        prompt: Text("예: 하나로마트 강남점")
                            .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.51))
                    )
                    .foregroundColor(Color.black)
                    .font(.system(size: 14))
                    .textFieldStyle(.plain)
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
                    TextField(
                        "",
                        text: $address,
                        prompt: Text("홍길동")
                            .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.51))
                    )
                    .foregroundColor(Color.black)
                    .font(.system(size: 14))
                    .textFieldStyle(.plain)
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
                    TextField(
                        "",
                        text: $brn,
                        prompt: Text("000-00-00000")
                            .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.51))
                    )
                    .foregroundColor(Color.black)
                    .font(.system(size: 14))
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                    .frame(width: 318, height: 41)
                    .background(
                        RoundedRectangle(cornerRadius: 7.5)
                            .fill(Color(red: 243/255, green: 243/255, blue: 245/255))
                    )
                        
                    //파일업로드 버튼
                    FileUploadView(selectedFileURL: $file)
                    //신청하기 버튼
                    SubmitButtonView(
                        name: $name,
                        address: $address,
                        brn: $brn,
                        file: $file
                    )
                }//입력 목록 VStack
                Spacer()
            }//HStack
            .padding(.horizontal, 40)
        }//입력란 큰 사각형 틀 ZStack
        Spacer()
    }
}

#Preview {
    PartnerFormView()
}
