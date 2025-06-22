//
//  OnboardingView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboarding: Bool
    @State private var currentPage = 0
    @State private var opacity = 0.0
    @State private var scale = 0.9
    @State private var backgroundOpacity = 0.0
    
    private let pages = [
        OnboardingPage(image: "map.fill", title: "Welcome to Wandr", description: "Your AI travel execution butler"),
        OnboardingPage(image: "text.bubble.fill", title: "Meet Alfred", description: "Describe your ideal adventure in natural language"),
        OnboardingPage(image: "calendar", title: "Instant Itineraries", description: "Get personalized plans that match your vibe and budget")
    ]
    
    var body: some View {
        ZStack {
            // Background pattern
            IndieBackgroundPattern()
                .opacity(backgroundOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        backgroundOpacity = 0.3
                    }
                }
            
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.black, .black.opacity(0.8), .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo
                Text("wandr")
                    .font(.custom("Futura", size: 56))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .tracking(2)
                    .scaleEffect(currentPage == 0 ? 1.0 : 0.6)
                    .opacity(currentPage == 0 ? 1.0 : 0.6)
                    .frame(height: currentPage == 0 ? 100 : 60)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                    .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: 0)
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            Image(systemName: pages[index].image)
                                .font(.system(size: 80))
                                .foregroundStyle(.white)
                                .frame(height: 120)
                                .padding(.bottom, 10)
                                .shadow(color: .white.opacity(0.2), radius: 8, x: 0, y: 0)
                            
                            Text(pages[index].title)
                                .font(.custom("Futura", size: 28))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Text(pages[index].description)
                                .font(.custom("Futura", size: 18))
                                .foregroundStyle(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .frame(maxWidth: 300)
                        }
                        .tag(index)
                        .opacity(opacity)
                        .scaleEffect(scale)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.6)) {
                                opacity = 1.0
                                scale = 1.0
                            }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Spacer()
                
                // Button with animated border
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeOut(duration: 0.7)) {
                            isOnboarding = false
                        }
                    }
                }) {
                    AnimatedBorderButton(text: currentPage < pages.count - 1 ? "Next" : "Get Started")
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                opacity = 1.0
                scale = 1.0
            }
        }
    }
}

// Indie-style background pattern
struct IndieBackgroundPattern: View {
    @State private var dotOpacity = 0.0
    
    var body: some View {
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
                withAnimation(.easeIn(duration: 2.0)) {
                    dotOpacity = 1.0
                }
            }
        }
    }
}

// Animated border button
struct AnimatedBorderButton: View {
    let text: String
    @State private var animationPhase: CGFloat = 0
    @State private var isPressed: Bool = false
    
    var body: some View {
        Text(text)
            .font(.custom("Futura", size: 18))
            .fontWeight(.medium)
            .foregroundStyle(.black)
            .frame(width: 280, height: 56)
            .background(
                ZStack {
                    // Button background
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    // Animated border
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.2), .white, .white.opacity(0.2)]),
                                startPoint: UnitPoint(x: animationPhase, y: animationPhase),
                                endPoint: UnitPoint(x: animationPhase + 1, y: animationPhase + 1)
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .onAppear {
                withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
                    animationPhase = 1.0
                }
            }
            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                isPressed = pressing
            }, perform: {})
    }
}

// Onboarding page data structure
struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

#Preview {
    OnboardingView(isOnboarding: .constant(true))
} 