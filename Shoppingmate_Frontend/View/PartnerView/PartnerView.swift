//
//  PartnerView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/31/25.
//

import SwiftUI

struct PartnerView: View {
    var body: some View {
        NavigationStack {
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
                    //입력폼
                    PartnerFormView()
                    
                }//VStack
            }//제일 뒷배경(연회색)
        }//navigationstack
    }
}

#Preview {
    PartnerView()
}
