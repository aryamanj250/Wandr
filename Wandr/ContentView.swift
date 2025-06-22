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
    
    var body: some View {
        ZStack {
            if isOnboarding {
                OnboardingView(isOnboarding: $isOnboarding)
            } else {
                MainView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
