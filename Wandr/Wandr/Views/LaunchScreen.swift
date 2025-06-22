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
    @State private var animateGradient = false
    @State private var dotOpacity = 0.0
    @State private var subtitleOffset: CGFloat = 10
    @State private var rotation: Double = 0
    
    var onFinished: () -> Void
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black, 
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color.black
                ]),
                startPoint: animateGradient ? .topLeading : .bottomLeading,
                endPoint: animateGradient ? .bottomTrailing : .topTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
            // Indie style background pattern
            GeometryReader { geometry in
                ZStack {
                    // Scattered dots
                    ForEach(0..<100, id: \.self) { index in
                        Circle()
                            .fill(Color.white.opacity(Double.random(in: 0.1...0.3)))
                            .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .opacity(dotOpacity)
                    }
                }
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        dotOpacity = 1.0
                    }
                }
            }
            
            // Decorative elements
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                .frame(width: 300, height: 300)
                .rotationEffect(Angle(degrees: rotation))
                .opacity(logoOpacity * 0.5)
            
            Circle()
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                .frame(width: 200, height: 200)
                .rotationEffect(Angle(degrees: -rotation))
                .opacity(logoOpacity * 0.7)
            
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
                    
                    Text("- indie vibes -")
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
    
    private func animateLogo() {
        // Start rotation animation
        withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        // Initial fade in and scale
        withAnimation(.easeOut(duration: 0.7)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        // Letter spacing animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                letterSpacing = 2
            }
        }
        
        // Subtitle animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                subtitleOffset = 0
            }
        }
        
        // Finish animation and call completion after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeIn(duration: 0.5)) {
                logoScale = 1.1
                logoOpacity = 0.0
                dotOpacity = 0.0
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