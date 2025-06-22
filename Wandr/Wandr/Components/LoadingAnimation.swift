//
//  LoadingAnimation.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI
import Combine

struct LoadingAnimation: View {
    let animationDuration: Double = 2.0
    
    @State private var isAnimating = false
    @State private var dashPhase: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var dotScale: CGFloat = 0.5
    @State private var innerRotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var indicatorOpacity = 0.7
    
    var body: some View {
        ZStack {
            // Outer circle
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.7),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.7)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        dash: [3, 8],
                        dashPhase: dashPhase
                    )
                )
                .frame(width: 60, height: 60)
                .rotationEffect(Angle(degrees: rotation))
                
            // Middle circle
            Circle()
                .stroke(
                    Color.white.opacity(0.2),
                    style: StrokeStyle(
                        lineWidth: 1.5,
                        lineCap: .round,
                        dash: [2, 6]
                    )
                )
                .frame(width: 40, height: 40)
                .rotationEffect(Angle(degrees: -innerRotation))
            
            // Inner circle with logo
            Circle()
                .fill(Color.black)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .scaleEffect(pulseScale)
                .overlay(
                    Text("w")
                        .font(.custom("Futura", size: 14))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .opacity(indicatorOpacity)
                )
            
            // Orbiting dots
            ForEach(0..<3) { index in
                let angle = Double(index) * 120.0
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 5, height: 5)
                    .offset(y: -22)
                    .rotationEffect(Angle(degrees: rotation + angle))
                    .opacity(isAnimating ? 0.8 : 0.4)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            isAnimating = true
            indicatorOpacity = 1.0
        }
        
        withAnimation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
            self.rotation = 360
            self.dashPhase = -20
        }
        
        withAnimation(Animation.linear(duration: animationDuration * 1.5).repeatForever(autoreverses: false)) {
            self.innerRotation = -360
        }
        
        withAnimation(Animation.easeInOut(duration: animationDuration/3).repeatForever(autoreverses: true)) {
            self.dotScale = 1.0
            self.pulseScale = 1.05
        }
    }
}

// Loading overlay to be used over full screens
struct LoadingOverlay: View {
    @State private var message = "Creating your adventure"
    @State private var dots = ""
    @State private var dotCount = 0
    
    // Timer for typing animation
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Blurred background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.8), 
                    Color(red: 0.1, green: 0.1, blue: 0.2).opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Background pattern
            GeometryReader { geometry in
                ForEach(0..<40, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.05...0.1)))
                        .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            
            VStack(spacing: 25) {
                LoadingAnimation()
                
                Text("\(message)\(dots)")
                    .font(.custom("Futura", size: 16))
                    .foregroundStyle(.white.opacity(0.9))
                    .onReceive(timer) { _ in
                        dotCount = (dotCount + 1) % 4
                        dots = String(repeating: ".", count: dotCount)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.05))
                    )
            }
        }
    }
}

#Preview {
    LoadingAnimation()
        .preferredColorScheme(.dark)
} 
