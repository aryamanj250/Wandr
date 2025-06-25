//
//  WandrApp.swift
//  Wandr
//
//  Created by aryaman jaiswal on 22/06/25.
//

import SwiftUI

@main
struct WandrApp: App {
    @State private var showLaunchScreen = true
    @State private var appScale: CGFloat = 0.8
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .opacity(showLaunchScreen ? 0 : 1)
                    .scaleEffect(appScale)
                    .environmentObject(SpeechManager())
                
                if showLaunchScreen {
                    LaunchScreen {
                        // Enhanced launch animation with Apple-like transitions
                        withAnimation(AppleAnimations.elasticScale(intensity: 1.2)) {
                            appScale = 1.05
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(AppleAnimations.gentleSpring) {
                                showLaunchScreen = false
                                appScale = 1.0
                            }
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
