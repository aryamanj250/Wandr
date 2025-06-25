//
//  HomeView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI
import Combine

struct HomeView: View {
    @State private var showVoiceInterface = false
    @State private var upcomingTrips: [UpcomingTrip] = []
    @State private var currentTime = Date()
    @State private var contentOpacity: Double = 0
    @State private var headerOffset: CGFloat = -50
    @State private var voiceButtonScale: CGFloat = 0.8
    @State private var glassOpacity: Double = 1.0
    @State private var showVoiceAnimation = false
    @State private var isRecordingVoice = false // This state is now managed by SpeechManager
    @State private var transcribedText: String = ""
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Enhanced background
            ProgressiveBlurBackground(intensity: 1.0)
                .ignoresSafeArea()
            
            // Main content
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: AppleDesign.Spacing.sectionSpacing) {
                    // App title with improved spacing
                    appTitleSection
                        .padding(.top, AppleDesign.Spacing.xl)
                        .offset(y: headerOffset)
                        .opacity(contentOpacity)
                    
                    // Enhanced voice interaction section
                    voiceInteractionSection
                        .appleScaleIn(delay: 0.2, initialScale: 0.9)
                    
                    // Current trip with live agent activities
                    // This section has been temporarily removed to fix build errors.
                    
                    // Upcoming trips with staggered animation
                    if !upcomingTrips.isEmpty {
                        upcomingTripsSection
                            .appleSlideIn(from: .bottom, delay: 0.6)
                    }
                }
                .padding(.horizontal, AppleDesign.Spacing.screenPadding)
                .padding(.bottom, 120) // Account for custom tab bar
            }
            
            // Voice interface overlay with enhanced blur
            if showVoiceInterface {
                voiceInterfaceOverlay
            }
            
            // VoiceInputView is now presented in the overlay
        }
        .navigationBarHidden(true)
        .onAppear {
            currentTime = Date()
            startEntranceAnimation()
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
    
    // MARK: - Animation Helper
    private func startEntranceAnimation() {
        withAnimation(AppleAnimations.fadeTransition.delay(0.1)) {
            contentOpacity = 1.0
        }
        
        withAnimation(AppleAnimations.gentleSpring.delay(0.1)) {
            headerOffset = 0
        }
        
        withAnimation(AppleAnimations.elasticScale().delay(0.3)) {
            voiceButtonScale = 1.0
        }
    }
    
    // MARK: - App Title Section
    private var appTitleSection: some View {
        VStack(alignment: .leading, spacing: AppleDesign.Spacing.xs) {
            HStack {
                Text("Wandr")
                    .font(AppleDesign.Typography.appTitle)
                    .foregroundStyle(AppleDesign.Colors.textPrimary)
                
                Spacer()
            }
            
            HStack {
                Text("AI Travel Concierge")
                    .font(AppleDesign.Typography.subheadline)
                    .foregroundStyle(AppleDesign.Colors.textSecondary)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Voice Interaction Section
    private var voiceInteractionSection: some View {
        VStack(spacing: AppleDesign.Spacing.lg) {
            Text("Ready to plan your next trip?")
                .font(AppleDesign.Typography.title3)
                .foregroundStyle(AppleDesign.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .appleFadeIn(delay: 0.1)
            
            // Enhanced glass voice button
            enhancedVoiceButton
                .scaleEffect(voiceButtonScale)
        }
        .padding(.vertical, AppleDesign.Spacing.xl)
    }
    
    // MARK: - Enhanced Voice Button
    private var enhancedVoiceButton: some View {
        Button(action: handleEnhancedVoiceButtonTap) {
            ZStack {
                // Pulsing outer rings
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(AppleDesign.Colors.borderAccent, lineWidth: 1)
                        .frame(width: 140 + CGFloat(i * 20), height: 140 + CGFloat(i * 20))
                        .scaleEffect(showVoiceAnimation ? 1.3 : 1.0)
                        .opacity(showVoiceAnimation ? 0 : 0.6 - Double(i) * 0.2)
                        .animation(
                            AppleAnimations.easeOut.delay(Double(i) * 0.1),
                            value: showVoiceAnimation
                        )
                }
                
                // Main button with glass effect
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .fill(AppleDesign.Colors.surface)
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        AppleDesign.Colors.borderAccent,
                                        AppleDesign.Colors.border
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: AppleDesign.Colors.shadowMedium, radius: 20, x: 0, y: 10)
                    .overlay(
                        VStack(spacing: AppleDesign.Spacing.sm) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundStyle(AppleDesign.Colors.textPrimary)
                            
                            Text("Plan Trip")
                                .font(AppleDesign.Typography.caption1)
                                .foregroundStyle(AppleDesign.Colors.textSecondary)
                        }
                    )
                    .scaleEffect(showVoiceAnimation ? 1.05 : 1.0)
                
                // Subtle inner glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                AppleDesign.Colors.accent.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .opacity(showVoiceAnimation ? 0.8 : 0.3)
            }
        }
        .floatingActionButton()
    }
    
    private func handleEnhancedVoiceButtonTap() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        withAnimation(AppleAnimations.elasticScale(intensity: 1.2)) {
            showVoiceAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(AppleAnimations.modalPresentation) {
                showVoiceInterface = true
            }
        }
    }
    
    // MARK: - Voice Interface Overlay
    private var voiceInterfaceOverlay: some View {
        VoiceInputView(text: $transcribedText, onSend: handleVoiceInputSend)
            .edgesIgnoringSafeArea(.all)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            ))
    }
    
    private func handleVoiceInputSend(text: String) {
        print("Voice input sent: \(text)")
        
        let networkService = NetworkService()
        networkService.sendTextCommand(text: text) { result in
            switch result {
            case .success(let taskId):
                print("Task ID: \(taskId)")
                // You can now use this task ID to poll for the result
            case .failure(let error):
                print("Error sending text command: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Glass Voice Button
    private var glassVoiceButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showVoiceAnimation = true
                voiceButtonScale = 1.2
                glassOpacity = 0.7
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    showVoiceInterface = true
                }
            }
        }) {
            ZStack {
                // Outer glass ring
                Circle()
                    .stroke(.white.opacity(0.2), lineWidth: 2)
                    .frame(width: 120, height: 120)
                    .scaleEffect(showVoiceAnimation ? 1.3 : 1.0)
                    .opacity(showVoiceAnimation ? 0 : 1)
                
                // Main button
                Circle()
                    .fill(.black.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.2), lineWidth: 2)
                    )
                    .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 0)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.white)
                            
                            Text("Plan Trip")
                                .font(.custom("Futura", size: 12))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    )
                    .scaleEffect(voiceButtonScale)
                    .opacity(glassOpacity)
                
                // Pulsing animation
                if showVoiceAnimation {
                    ForEach(0..<3) { i in
                        Circle()
                            .stroke(.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 100, height: 100)
                            .scaleEffect(1.0 + Double(i) * 0.3)
                            .opacity(1.0 - Double(i) * 0.3)
                            .animation(
                                Animation.easeOut(duration: 1.5)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(i) * 0.2),
                                value: showVoiceAnimation
                            )
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    
    // MARK: - Upcoming Trips Section
    private var upcomingTripsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Planned Trips")
                .font(.custom("Futura", size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 5)
            
            VStack(spacing: 20) {
                ForEach(upcomingTrips) { trip in
                    plannedTripWithAgents(trip)
                }
            }
        }
    }
    
    // MARK: - Planned Trip with Same UI as Live Trip
    private func plannedTripWithAgents(_ trip: UpcomingTrip) -> some View {
        VStack(spacing: 20) {
            // Section header - different from live trip
            HStack {
                Text("Planned Trip")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                // Agent status indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(.orange)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(.orange.opacity(0.3), lineWidth: 2)
                                .scaleEffect(1.5)
                        )
                    
                    Text("AGENTS PLANNING")
                        .font(.custom("Futura", size: 10))
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                        .tracking(1)
                }
            }
            
            // Use the same CurrentTripWithAgents component
            NavigationLink(destination: GoaTripDetailView(trip: trip)) {
                CurrentTripWithAgents(trip: trip) {
                    // Navigation handled by NavigationLink
                }
            }
            
            // Use the same CurrentTripWithAgents component
            NavigationLink(destination: GoaTripDetailView(trip: trip)) {
                CurrentTripWithAgents(trip: trip) {
                    // Navigation handled by NavigationLink
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
