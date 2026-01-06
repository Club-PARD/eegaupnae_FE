//
//  CurrentLocationButton.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/6/26.
//

import SwiftUI

//@StateObject private var viewModel: LocationSelectViewModel

struct CurrentLocationButton: View {
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image("currentLocation")
                .resizable()
                .frame(width: 22, height: 22)
                .padding(12)
                .frame(width: 46, height: 46)
                .background(Color.white)
                .cornerRadius(23)
                .shadow(color: .black.opacity(0.25), radius: 1.5)
        }
    }
}

#Preview {
    CurrentLocationButton {
            print("Tapped")
    }
}
