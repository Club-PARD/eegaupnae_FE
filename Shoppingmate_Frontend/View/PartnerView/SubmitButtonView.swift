//
//  SubmitButtonView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/3/26.
//

import SwiftUI

struct SubmitButtonView: View {
    @State private var isAfterSubmitActive = false
    
    var body: some View {
        Button {
            isAfterSubmitActive = true
        } label: {
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
        }
        .navigationDestination(isPresented: $isAfterSubmitActive) {
            AfterSubmitView()
        }
    }
}

#Preview {
    SubmitButtonView()
}
