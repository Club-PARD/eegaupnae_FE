//
//  LoginView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/30/25.
//

import SwiftUI
import Combine

enum UserType {
    case normal
    case partner
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var goToLocation = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 0.98)
                    .ignoresSafeArea(edges: .all)
                VStack(alignment: .leading) {
                    Spacer()
                    Image("PICPICK")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 147, height: 25)
                        .clipped()
                        .padding(.bottom, 25)
                    Text("초간단 온/오프라인 가격비표")
                      .font(Font.custom("Arial", size: 26))
                      .multilineTextAlignment(.center)
                      .foregroundColor(.black)
                      .padding(.bottom, 15)
                    Text("지금 바로,\n시작해 볼까요?")
                      .font(
                        Font.custom("Arial", size: 43)
                          .weight(.bold)
                      )
                      .foregroundColor(.black)
                      .padding(.bottom, 160)
                    VStack {
                        //게스트 로그인 버튼
                        HStack(alignment: .center, spacing: 8) {
                            ZStack {
                                Text("게스트 로그인")
                                  .font(Font.custom("Arial-BoldMT", size: 16))
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                            }//zstack
                            .onTapGesture {
                                viewModel.guestLogin()
                                goToLocation = true
                                //appState.userType = .normal
                            }
                            .buttonStyle(.plain)
                        } //hstack
                        .padding(.bottom,26)
                        .padding(.top, 150)
                 
                    }//버튼 VStack
        
                    //Spacer()
                }//vstack
            }//zstack
            .navigationDestination(isPresented: $goToLocation) {
                LocationSelectView()
            }
        }//navigationstack
    }
}

//
//#Preview {
//    LoginView()
//}
