//
//  PartnerFormView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/3/26.
//

import SwiftUI

struct PartnerFormView: View {
    @State private var selectedFileURL: URL?
    
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
                    
                //파일업로드 버튼
                FileUploadView(selectedFileURL: $selectedFileURL)
                
                //신청하기 버튼
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
    }
}

#Preview {
    PartnerFormView()
}
