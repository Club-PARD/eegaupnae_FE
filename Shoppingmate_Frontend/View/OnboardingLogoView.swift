//
//  OnboardingLogoView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/5/26.
//

import SwiftUI
import AVKit

struct OnboardingLogoView: View {
    
    let onFinished: () -> Void
    
    private let player = AVPlayer(
        url: Bundle.main.url(forResource: "logo", withExtension: "mp4")!
    )

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.isMuted = true
                player.play()
                
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem,
                    queue: .main
                ) { _ in
                    onFinished()
                }
            }
            .onDisappear {
                player.pause()
                NotificationCenter.default.removeObserver(self)
            }
    }
}
