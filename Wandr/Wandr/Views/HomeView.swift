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
    @State private var showVoiceAnimation = false
    @State private var isRecordingVoice = false // This state is now managed by SpeechManager
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            backgroundView
            mainContent
            voiceOverlayIfNeeded
        }
        .navigationBarHidden(true)
        .onAppear(perform: setupView)
        .onReceive(timer) { _ in currentTime = Date() }
    }

    private var backgroundView: some View {
        ProgressiveBlurBackground(intensity: 1.0)
            .ignoresSafeArea()
    }

    private var voiceOverlayIfNeeded: some View {
        Group {
            if showVoiceInterface {
                voiceInterfaceOverlay
            }
        }
    }
    
    private var mainContent: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: AppleDesign.Spacing.sectionSpacing) {
                appTitleSection
                    .padding(.top, AppleDesign.Spacing.xl)
                    .offset(y: headerOffset)
                    .opacity(contentOpacity)
                
                voiceInteractionSection
                    .appleScaleIn(delay: 0.2, initialScale: 0.9)
                
                if !upcomingTrips.isEmpty {
                    upcomingTripsSection
                        .appleSlideIn(from: .bottom, delay: 0.6)
                }
            }
            .padding(.horizontal, AppleDesign.Spacing.screenPadding)
            .padding(.bottom, 120)
        }
    }
    
    private func setupView() {
        currentTime = Date()
        startEntranceAnimation()
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
            
            EnhancedVoiceButton(
                showVoiceAnimation: $showVoiceAnimation,
                voiceButtonScale: voiceButtonScale,
                action: handleEnhancedVoiceButtonTap
            )
        }
        .padding(.vertical, AppleDesign.Spacing.xl)
    }
    
    private func handleEnhancedVoiceButtonTap() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        showVoiceInterface = true
    }
    
    // MARK: - Voice Interface Overlay
    private var voiceInterfaceOverlay: some View {
        VoiceGlassOverlay(isPresented: $showVoiceInterface)
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .scale(scale: 0.95)),
                removal: .opacity.combined(with: .scale(scale: 1.05))
            ))
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
                    PlannedTripWithAgentsView(trip: trip)
                }
            }
        }
    }
}

// MARK: - Helper Views (Moved to top-level)
private struct PulsingRingsView: View {
    let showVoiceAnimation: Bool
    
    var body: some View {
        ForEach(0..<3) { i in
            PulsingRing(index: i, showVoiceAnimation: showVoiceAnimation)
        }
    }
}

private struct PulsingRing: View {
    let index: Int
    let showVoiceAnimation: Bool
    
    var body: some View {
        Circle()
            .stroke(AppleDesign.Colors.borderAccent, lineWidth: 1)
            .frame(width: 140 + CGFloat(index * 20), height: 140 + CGFloat(index * 20))
            .scaleEffect(showVoiceAnimation ? 1.3 : 1.0)
            .opacity(showVoiceAnimation ? 0 : 0.6 - Double(index) * 0.2)
            .animation(
                AppleAnimations.easeOut
                ,
                value: showVoiceAnimation
            )
    }
}

private struct EnhancedVoiceButton: View {
    @Binding var showVoiceAnimation: Bool
    let voiceButtonScale: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                PulsingRingsView(showVoiceAnimation: showVoiceAnimation)
                VoiceButtonCoreView(showVoiceAnimation: showVoiceAnimation)
            }
        }
        .floatingActionButton()
        .scaleEffect(voiceButtonScale) // Apply scale effect here
    }
}

private struct VoiceButtonCoreView: View {
    let showVoiceAnimation: Bool
    
    var body: some View {
        ZStack {
            buttonBackground
            buttonContent
            pulsingRadialGradient
        }
    }
    
    private var buttonBackground: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .frame(width: 120, height: 120)
            .overlay(Circle().fill(AppleDesign.Colors.surface))
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
            .scaleEffect(showVoiceAnimation ? 1.05 : 1.0)
    }
    
    private var buttonContent: some View {
        VStack(spacing: AppleDesign.Spacing.sm) {
            Image(systemName: "mic.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(AppleDesign.Colors.textPrimary)
            
            Text("Plan Trip")
                .font(AppleDesign.Typography.caption1)
                .foregroundStyle(AppleDesign.Colors.textSecondary)
        }
    }
    
    private var pulsingRadialGradient: some View {
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

private struct PlannedTripWithAgentsView: View {
    let trip: UpcomingTrip
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Planned Trip")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                AgentStatusIndicator()
            }
            
            PlannedTripNavigationLink(trip: trip)
            PlannedTripNavigationLink(trip: trip)
        }
    }
}

private struct AgentStatusIndicator: View {
    var body: some View {
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
}

private struct PlannedTripNavigationLink: View {
    let trip: UpcomingTrip
    
    var body: some View {
        NavigationLink(destination: GoaTripDetailView(trip: trip)) {
            CurrentTripWithAgents(trip: trip) {
                // Navigation handled by NavigationLink
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
