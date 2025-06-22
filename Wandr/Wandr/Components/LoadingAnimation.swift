//
//  LoadingAnimation.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct LoadingAnimation: View {
    let strokeWidth: CGFloat = 2
    let animationDuration: Double = 2.0
    
    @State private var isAnimating = false
    @State private var dashPhase: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var dotScale: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            // Circular path
            Circle()
                .stroke(
                    Color.white.opacity(0.1),
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round,
                        dash: [5, 15],
                        dashPhase: dashPhase
                    )
                )
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: rotation))
            
            // Traveling dot
            Circle()
                .fill(Color.white)
                .frame(width: 8, height: 8)
                .offset(y: -25)  // Position at edge of circle
                .rotationEffect(Angle(degrees: rotation))
                .scaleEffect(dotScale)
            
            // Center text
            Text("wandr")
                .font(.custom("Futura", size: 12))
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .opacity(isAnimating ? 0.6 : 0.4)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            
            withAnimation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                self.rotation = 360
                self.dashPhase = -40
            }
            
            withAnimation(Animation.easeInOut(duration: animationDuration/4).repeatForever(autoreverses: true)) {
                self.dotScale = 1.0
            }
        }
    }
}

// Loading overlay to be used over full screens
struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                LoadingAnimation()
                
                Text("Creating your adventure...")
                    .font(.custom("Futura", size: 16))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
    }
}

#Preview {
    LoadingAnimation()
        .preferredColorScheme(.dark)
} 