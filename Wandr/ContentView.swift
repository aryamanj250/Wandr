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
    
    var body: some View {
        ZStack {
            // Indie-style background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black, 
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .opacity(backgroundOpacity)
            
            // Content
            if isOnboarding {
                OnboardingView(isOnboarding: $isOnboarding)
            } else {
                MainView()
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeIn(duration: 1.5)) {
                backgroundOpacity = 1.0
            }
        }
    }
}

#Preview {
    ContentView()
}
