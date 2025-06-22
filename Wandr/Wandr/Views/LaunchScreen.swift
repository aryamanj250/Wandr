//
//  LaunchScreen.swift
//  Wandr
//
//  Created by Aryaman Jaiswal on 23/06/25.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var letterSpacing: CGFloat = -5
    @State private var isFinished = false
    @State private var subtitleOffset: CGFloat = 10
    
    var onFinished: () -> Void
    
    var body: some View {
        ZStack {
            // Clean black background
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // Logo
            VStack(spacing: 20) {
                Text("wandr")
                    .font(.custom("Futura", size: 60))
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .white.opacity(0.8)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .tracking(letterSpacing)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: 0)
                
                VStack(spacing: 4) {
                    Text("your travel butler")
                        .font(.custom("Futura", size: 18))
                        .foregroundStyle(.white.opacity(0.7))
                        .opacity(logoOpacity * 0.7)
                        .offset(y: subtitleOffset)
                    
                    Text("- minimalist -")
                        .font(.custom("Futura", size: 14))
                        .italic()
                        .tracking(1)
                        .foregroundStyle(.white.opacity(0.5))
                        .opacity(logoOpacity * 0.5)
                        .offset(y: subtitleOffset * 2)
                }
            }
        }
        .onAppear {
            animateLogo()
        }
    }
    
    // Animate the logo entry and finish
    private func animateLogo() {
        // Animate logo entry
        withAnimation(.easeOut(duration: 1.2)) {
            logoScale = 1.0
            logoOpacity = 1.0
            letterSpacing = 2
            subtitleOffset = 0
        }
        
        // Exit after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(.easeIn(duration: 0.8)) {
                logoOpacity = 0
                logoScale = 1.2
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isFinished = true
                onFinished()
            }
        }
    }
}

#Preview {
    LaunchScreen {}
} 