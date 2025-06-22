//
//  LaunchScreen.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var letterSpacing: CGFloat = -5
    @State private var isFinished = false
    
    var onFinished: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Logo
            VStack(spacing: 20) {
                Text("wandr")
                    .font(.custom("Futura", size: 60))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .tracking(letterSpacing)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                Text("your travel butler")
                    .font(.custom("Futura", size: 18))
                    .foregroundStyle(.white.opacity(0.7))
                    .opacity(logoOpacity * 0.7)
                    .offset(y: letterSpacing == -5 ? 10 : 0)
            }
        }
        .onAppear {
            animateLogo()
        }
    }
    
    private func animateLogo() {
        // Initial fade in and scale
        withAnimation(.easeOut(duration: 0.7)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        // Letter spacing animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                letterSpacing = 1.5
            }
        }
        
        // Finish animation and call completion after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeIn(duration: 0.5)) {
                logoScale = 1.1
                logoOpacity = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFinished = true
                onFinished()
            }
        }
    }
}

#Preview {
    LaunchScreen(onFinished: {})
} 