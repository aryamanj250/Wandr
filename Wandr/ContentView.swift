//
//  ContentView.swift
//  Wandr
//
//  Created by aryaman jaiswal on 22/06/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isOnboarding = true
    @State private var backgroundOpacity = 0.0
    @State private var contentScale: CGFloat = 0.95
    
    var body: some View {
        ZStack {
            // Enhanced background with progressive blur
            ProgressiveBlurBackground(intensity: backgroundOpacity)
                .ignoresSafeArea()
            
            // Content with enhanced transitions
            Group {
                if isOnboarding {
                    OnboardingView(isOnboarding: $isOnboarding)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.9).combined(with: .opacity),
                            removal: .scale(scale: 1.1).combined(with: .opacity)
                        ))
                } else {
                    MainTabView()
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95).combined(with: .opacity),
                            removal: .scale(scale: 0.9).combined(with: .opacity)
                        ))
                }
            }
            .scaleEffect(contentScale)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startEntranceAnimation()
        }
        .onChange(of: isOnboarding) {
            // Smooth transition when moving between onboarding and main app
            withAnimation(AppleAnimations.gentleSpring) {
                contentScale = 0.98
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(AppleAnimations.elasticScale()) {
                    contentScale = 1.0
                }
            }
        }
    }
    
    private func startEntranceAnimation() {
        withAnimation(AppleAnimations.fadeTransition.delay(0.2)) {
            backgroundOpacity = 1.0
        }
        
        withAnimation(AppleAnimations.gentleSpring.delay(0.3)) {
            contentScale = 1.0
        }
    }
}

#Preview {
    ContentView()
}
