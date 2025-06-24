//
//  OnboardingView.swift
//  Wandr
//
//  Created by aryaman jaiswal on 23/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboarding: Bool
    @State private var currentPage = 0
    @State private var dragOffset: CGFloat = 0
    @State private var contentOpacity: Double = 0
    @State private var logoOpacity: Double = 0
    @State private var headerOffset: CGFloat = -30
    
    // Monotonic design with consistent SF Symbols
    private let pages = [
        OnboardingPage(
            title: "Welcome to Wandr",
            subtitle: "AI Travel Concierge",
            description: "Intelligent planning meets effortless execution for perfect journeys",
            icon: "airplane.departure",
            step: "01"
        ),
        OnboardingPage(
            title: "Meet Alfred",
            subtitle: "Your Digital Butler",
            description: "Natural conversation creates personalized itineraries in real-time",
            icon: "brain.head.profile",
            step: "02"
        ),
        OnboardingPage(
            title: "Live Intelligence",
            subtitle: "Dynamic Adaptation",
            description: "Active monitoring with smart adjustments throughout your journey",
            icon: "sensor.tag.radiowaves.forward",
            step: "03"
        ),
        OnboardingPage(
            title: "Begin Your Journey",
            subtitle: "Seamless Experience",
            description: "Join travelers worldwide experiencing perfect trip execution",
            icon: "location.north.circle",
            step: "04"
        )
    ]
    
    var body: some View {
        ZStack {
            // Clean monochromatic background
            monochromaticBackground
            
            VStack(spacing: 0) {
                // Precise header
                headerSection
                
                // Main content with calculated spacing
                contentSection
                
                // Minimal controls
                controlsSection
            }
            .opacity(contentOpacity)
        }
        .onAppear {
            executeEntranceSequence()
        }
        .gesture(preciseSwipeGesture)
    }
    
    // MARK: - Monochromatic Background
    private var monochromaticBackground: some View {
        ZStack {
            // Base background matching app
            ProgressiveBlurBackground(intensity: 1.0)
            
            // Subtle radial overlay for depth
            RadialGradient(
                colors: [
                    Color.clear,
                    AppleDesign.Colors.background.opacity(0.3)
                ],
                center: .topTrailing,
                startRadius: 100,
                endRadius: 400
            )
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Calculated Header
    private var headerSection: some View {
        VStack(spacing: AppleDesign.Spacing.md) {
            Spacer()
                .frame(height: 60)
            
            // Logo with precise typography
            VStack(spacing: AppleDesign.Spacing.xs) {
                Text("Wandr")
                    .font(currentPage == 0 ? AppleDesign.Typography.extraLargeTitle : AppleDesign.Typography.largeTitle)
                    .foregroundStyle(AppleDesign.Colors.textPrimary)
                    .tracking(1.5)
                    .opacity(logoOpacity)
                    .offset(y: headerOffset)
                    .animation(AppleAnimations.spring, value: currentPage)
                
                if currentPage == 0 {
                    Text("AI Travel Concierge")
                        .font(AppleDesign.Typography.caption1)
                        .foregroundStyle(AppleDesign.Colors.textSecondary)
                        .tracking(2.0)
                        .opacity(logoOpacity)
                        .appleFadeIn(delay: 0.8)
                }
            }
            
            Spacer()
                .frame(height: currentPage == 0 ? 30 : 20)
        }
    }
    
    // MARK: - Precise Content
    private var contentSection: some View {
        GeometryReader { geometry in
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    ProfessionalOnboardingCard(
                        page: pages[index],
                        isActive: currentPage == index,
                        availableHeight: geometry.size.height
                    )
                    .tag(index)
                    .offset(x: dragOffset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(AppleAnimations.smoothTransition, value: currentPage)
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
    }
    
    // MARK: - Minimal Controls
    private var controlsSection: some View {
        VStack(spacing: AppleDesign.Spacing.lg) {
            // Step indicators
            stepIndicators
            
            // Navigation
            navigationControls
            
            Spacer()
                .frame(height: 40)
        }
        .padding(.horizontal, AppleDesign.Spacing.screenPadding)
        .padding(.bottom, 20)
    }
    
    private var stepIndicators: some View {
        HStack(spacing: AppleDesign.Spacing.sm) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(
                        currentPage == index 
                        ? AppleDesign.Colors.textPrimary
                        : AppleDesign.Colors.textPrimary.opacity(0.2)
                    )
                    .frame(width: 6, height: 6)
                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                    .animation(AppleAnimations.spring, value: currentPage)
            }
        }
        .padding(.vertical, AppleDesign.Spacing.lg)
    }
    
    private var navigationControls: some View {
        HStack(spacing: AppleDesign.Spacing.lg) {
            // Back button
            if currentPage > 0 {
                Button(action: previousStep) {
                    HStack(spacing: AppleDesign.Spacing.xs) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text("Back")
                            .font(AppleDesign.Typography.buttonText)
                    }
                    .foregroundStyle(AppleDesign.Colors.textSecondary)
                    .padding(.horizontal, AppleDesign.Spacing.lg)
                    .padding(.vertical, AppleDesign.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppleDesign.CornerRadius.button)
                            .fill(AppleDesign.Colors.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppleDesign.CornerRadius.button)
                                    .stroke(AppleDesign.Colors.border, lineWidth: 0.5)
                            )
                    )
                }
                .appleSlideIn(from: .leading, delay: 0.1)
            }
            
            Spacer()
            
            // Primary action
            Button(action: nextStep) {
                HStack(spacing: AppleDesign.Spacing.sm) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(AppleDesign.Typography.buttonText)
                        .tracking(0.3)
                    
                    Image(systemName: currentPage < pages.count - 1 ? "arrow.right" : "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(AppleDesign.Colors.background)
                .padding(.horizontal, AppleDesign.Spacing.xl)
                .padding(.vertical, AppleDesign.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppleDesign.CornerRadius.button)
                        .fill(AppleDesign.Colors.textPrimary)
                )
            }
            .appleButtonPress(action: {})
        }
    }
    
    // MARK: - Gesture Handling
    private var preciseSwipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let resistance: CGFloat = 0.3
                dragOffset = value.translation.width * resistance
            }
            .onEnded { value in
                handleSwipeCompletion(value.translation.width)
            }
    }
    
    // MARK: - Methods
    private func executeEntranceSequence() {
        withAnimation(AppleAnimations.fadeTransition.delay(0.1)) {
            contentOpacity = 1.0
        }
        
        withAnimation(AppleAnimations.spring.delay(0.2)) {
            logoOpacity = 1.0
            headerOffset = 0
        }
    }
    
    private func nextStep() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        if currentPage < pages.count - 1 {
            withAnimation(AppleAnimations.spring) {
                currentPage += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    private func previousStep() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        if currentPage > 0 {
            withAnimation(AppleAnimations.spring) {
                currentPage -= 1
            }
        }
    }
    
    private func completeOnboarding() {
        withAnimation(AppleAnimations.modalPresentation) {
            contentOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isOnboarding = false
        }
    }
    
    private func handleSwipeCompletion(_ translation: CGFloat) {
        let threshold: CGFloat = 80
        
        if translation > threshold && currentPage > 0 {
            previousStep()
        } else if translation < -threshold && currentPage < pages.count - 1 {
            nextStep()
        }
        
        withAnimation(AppleAnimations.spring) {
            dragOffset = 0
        }
    }
}

// MARK: - Professional Card Component
struct ProfessionalOnboardingCard: View {
    let page: OnboardingPage
    let isActive: Bool
    let availableHeight: CGFloat
    
    @State private var iconScale: CGFloat = 0.9
    @State private var textOpacity: Double = 0
    @State private var stepOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: spacing) {
            // Step indicator
            stepIndicator
                .opacity(stepOpacity)
            
            Spacer()
                .frame(height: 10)
            
            // Icon with precise design
            iconSection
                .scaleEffect(iconScale)
            
            Spacer()
                .frame(height: 20)
            
            // Content with calculated hierarchy
            contentSection
                .opacity(textOpacity)
            
            Spacer()
        }
        .padding(.horizontal, AppleDesign.Spacing.lg)
        .onChange(of: isActive) { _, newValue in
            animateContent(newValue)
        }
        .onAppear {
            if isActive {
                animateContent(true)
            }
        }
    }
    
    private var spacing: CGFloat {
        // Adaptive spacing based on available height
        if availableHeight < 400 {
            return AppleDesign.Spacing.lg
        } else {
            return AppleDesign.Spacing.xl
        }
    }
    
    private var stepIndicator: some View {
        HStack(spacing: AppleDesign.Spacing.xs) {
            Text("STEP")
                .font(AppleDesign.Typography.label)
                .tracking(1.5)
                .foregroundStyle(AppleDesign.Colors.textTertiary)
            
            Text(page.step)
                .font(AppleDesign.Typography.label)
                .tracking(1.5)
                .foregroundStyle(AppleDesign.Colors.textSecondary)
        }
        .padding(.horizontal, AppleDesign.Spacing.md)
        .padding(.vertical, AppleDesign.Spacing.xs)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AppleDesign.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppleDesign.Colors.border, lineWidth: 0.5)
                )
        )
    }
    
    private var iconSection: some View {
        ZStack {
            // Minimal background
            Circle()
                .fill(AppleDesign.Colors.surface)
                .frame(width: iconSize, height: iconSize)
                .overlay(
                    Circle()
                        .stroke(AppleDesign.Colors.border, lineWidth: 0.5)
                )
            
            // SF Symbol with precise sizing
            Image(systemName: page.icon)
                .font(.system(size: symbolSize, weight: .light))
                .foregroundStyle(AppleDesign.Colors.textPrimary)
        }
        .shadow(color: AppleDesign.Colors.shadowLight, radius: 6, x: 0, y: 3)
    }
    
    private var iconSize: CGFloat {
        availableHeight < 400 ? 80 : 100
    }
    
    private var symbolSize: CGFloat {
        availableHeight < 400 ? 28 : 36
    }
    
    private var contentSection: some View {
        VStack(spacing: textSpacing) {
            Text(page.title)
                .font(availableHeight < 400 ? AppleDesign.Typography.title3 : AppleDesign.Typography.title2)
                .foregroundStyle(AppleDesign.Colors.textPrimary)
                .multilineTextAlignment(.center)
                .tracking(0.3)
                .lineLimit(2)
            
            Text(page.subtitle)
                .font(availableHeight < 400 ? AppleDesign.Typography.subheadline : AppleDesign.Typography.headline)
                .foregroundStyle(AppleDesign.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .tracking(0.2)
                .lineLimit(1)
            
            Text(page.description)
                .font(availableHeight < 400 ? AppleDesign.Typography.footnote : AppleDesign.Typography.callout)
                .foregroundStyle(AppleDesign.Colors.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .lineSpacing(1)
                .padding(.horizontal, AppleDesign.Spacing.sm)
        }
    }
    
    private var textSpacing: CGFloat {
        availableHeight < 400 ? AppleDesign.Spacing.md : AppleDesign.Spacing.lg
    }
    
    private var titleSize: CGFloat {
        availableHeight < 400 ? 24 : 28
    }
    
    private var subtitleSize: CGFloat {
        availableHeight < 400 ? 16 : 18
    }
    
    private var descriptionSize: CGFloat {
        availableHeight < 400 ? 14 : 16
    }
    
    private func animateContent(_ active: Bool) {
        if active {
            withAnimation(AppleAnimations.spring.delay(0.1)) {
                iconScale = 1.0
            }
            withAnimation(AppleAnimations.fadeTransition.delay(0.2)) {
                textOpacity = 1.0
            }
            withAnimation(AppleAnimations.fadeTransition.delay(0.3)) {
                stepOpacity = 1.0
            }
        } else {
            iconScale = 0.95
            textOpacity = 0.6
            stepOpacity = 0.4
        }
    }
}

// MARK: - Data Models
struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let step: String
}

#Preview {
    OnboardingView(isOnboarding: .constant(true))
}
