//
//  OnboardingView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 12/30/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var nextView: NextView?
    
    enum NextView: Identifiable {
        case select
        case normalMain
        case partnerMain
        
        var id: Int {
                switch self {
                case .select: return 0
                case .normalMain: return 1
                case .partnerMain: return 2
                }
            }
    }
    
    var body: some View {
        ZStack {
            Color(red:65/255, green: 71/255, blue: 155/255)
                .ignoresSafeArea(edges: .all)
            
            Image("picpickLogo")
                .resizable()
                .frame(width: 121, height: 144)
        }
        .onAppear {
            //DispatchQueue.main.asyncAfter: 메인 스레드에서, 특정 시간 뒤에 실행해줘(지금으로부터 1.5초 뒤에 route함수 실행)
            // -> 로고 1.5초 보여주고 다음 화면으로 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                route()
            }
        }
        .fullScreenCover(item: $nextView) { view in
            switch view {
            case .select:
                SelectView()
            case .normalMain:
                CameraOCRView()
            case .partnerMain:
                PartnerView()
            }
        }
    }
    
    private func route() {
            let isNormalUser =
                //UserDefaults: 앱에 작은 값을 저장해두는 로컬 저장소
                //isNormalUser라는 키로 저장된 값을 가져오기.(저장된 게 없으면 nil)
                //as? Bool: 가져온 값을 bool로 변환 시도
                UserDefaults.standard.object(forKey: "isNormalUser") as? Bool

            if isNormalUser == nil {
                nextView = .select
            } else if isNormalUser == true {
                nextView = .normalMain
            } else {
                nextView = .partnerMain
            }
        }
}

#Preview {
    OnboardingView()
}
