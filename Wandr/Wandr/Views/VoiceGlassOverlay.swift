//
//  VoiceGlassOverlay.swift
//  Wandr
//
//  Created by Claude Code on 26/06/25.
//

import SwiftUI

struct VoiceGlassOverlay: View {
    @Binding var isPresented: Bool
    @StateObject private var speechManager = SpeechManager()
    @State private var isListening = false
    @State private var isProcessing = false
    @State private var hasError = false
    @State private var transcribedWords: [String] = []
    @State private var showItinerary = false
    @State private var itineraryResponse: ItineraryResponse?
    @State private var isEditingText = false
    @State private var editableText = ""
    @FocusState private var isTextFieldFocused: Bool
    
    // Animation states
    @State private var showVoiceAnimation = false
    
    // Gemini API Key - TODO: Move to secure storage
    private let geminiAPIKey = "AIzaSyDdFD-mjb4IzqVRvh-FTh6wKhURCU_bf9E"
    
    var body: some View {
        ZStack {
            // Full-screen liquid glass background with corner rounding fix
            liquidGlassBackground
                .onTapGesture {
                    // Tap anywhere empty to close
                    closeOverlay()
                }
            
            // Main content
            VStack {
                // Text display area - animates to top when editing
                if isEditingText {
                    // Editable text at top when editing
                    editableTextArea
                        .padding(.top, 60)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                } else {
                    Spacer()
                    
                    // Center voice interaction area
                    if !isProcessing {
                        voiceInteractionArea
                            .padding(.top, 50.5)
                            .padding(.bottom, 80)
                    } else {
                        simpleLoadingSpinner
                            .padding(.top, 50.5)
                    }
                    
                    Spacer()
                    
                    // Text display area with auto-scroll (bottom when not editing)
                    if !isProcessing {
                        transcribedTextArea
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    // Bottom padding
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 60)
                }
            }
        }
        .onAppear {
            setupSpeechManager()
            // Start listening immediately when overlay appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startListening()
            }
        }
        .onChange(of: speechManager.transcribedText) { newText in
            processTranscribedText(newText)
        }
        .onChange(of: isTextFieldFocused) { focused in
            if !focused && isEditingText {
                // Keyboard was dismissed - just exit editing mode without sending request
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isEditingText = false
                }
            }
        }
        .fullScreenCover(isPresented: $showItinerary) {
            if let response = itineraryResponse {
                ItineraryView(itineraryResponse: response, isShowing: $showItinerary)
            }
        }
    }
    
    // MARK: - Background with proper corner handling
    private var liquidGlassBackground: some View {
        Rectangle()
            .fill(.black.opacity(0.2))
            .glassEffect(.regular.tint(.black.opacity(0.1)), in: .rect)
            .ignoresSafeArea(.all) // This ensures full coverage including corners
    }
    
    // MARK: - Simple Loading Spinner
    private var simpleLoadingSpinner: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text("Planning your adventure...")
                .font(AppleDesign.Typography.title3)
                .foregroundStyle(AppleDesign.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Voice Interaction Area (Original Design)
    private var voiceInteractionArea: some View {
        VStack(spacing: 55) {  //was 48.5
            // Text above button (matching HomeView layout) - fixed height
            VStack {
                if transcribedWords.isEmpty && !isListening {
                    Text("Ready to plan your next trip?")
                        .font(AppleDesign.Typography.title3)
                        .foregroundStyle(AppleDesign.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 24) // Fixed height to prevent button shifting
            
            // Use exact HomeView voice button design - only hide when editing
            if !isEditingText {
                homeViewStyleVoiceButton
            }
        }
    }
    
    // MARK: - HomeView Style Voice Button (Exact Copy Restored)
    private var homeViewStyleVoiceButton: some View {
        Button(action: handleVoiceButtonTap) {
            ZStack {
                // Pulsing rings (glow effect) - only when listening
                if isListening {
                    pulsingGlowEffect
                }
                
                // Core button (exact copy from HomeView)
                voiceButtonCore
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var pulsingGlowEffect: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        AppleDesign.Colors.accent.opacity(0.4),
                        AppleDesign.Colors.accent.opacity(0.2),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 80
                )
            )
            .frame(width: 160, height: 160)
            .scaleEffect(showVoiceAnimation ? 1.3 : 1.0)
            .opacity(showVoiceAnimation ? 1.0 : 0.5)
            .animation(
                Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                value: showVoiceAnimation
            )
    }
    
    private var voiceButtonCore: some View {
        ZStack {
            // Button background with glass effect
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(
                            hasError ? 
                            LinearGradient(
                                colors: [.red, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [
                                    AppleDesign.Colors.borderAccent,
                                    AppleDesign.Colors.border
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: hasError ? 4 : 1
                        )
                )
                .shadow(color: AppleDesign.Colors.shadowMedium, radius: 20, x: 0, y: 10)
                .scaleEffect(showVoiceAnimation ? 1.05 : 1.0)
            
            // Button content - exact copy from HomeView
            VStack(spacing: AppleDesign.Spacing.sm) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(AppleDesign.Colors.textPrimary)
                
                Text(isListening ? "Listening..." : "Plan Trip")
                    .font(AppleDesign.Typography.caption1)
                    .foregroundStyle(AppleDesign.Colors.textSecondary)
            }
            
        }
    }
    
    // MARK: - Editable Text Area (Top of Screen)
    private var editableTextArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                TextField("Type your travel request...", text: $editableText, axis: .vertical)
                    .font(AppleDesign.Typography.title3)
                    .foregroundStyle(.white)
                    .focused($isTextFieldFocused)
                    .submitLabel(.done)
                    .lineLimit(1...5)
                    .onSubmit {
                        finishTextEditing()
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                finishTextEditing()
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 30)
            }
            .frame(maxHeight: 200)
        }
    }
    
    // MARK: - Text Display with Auto-scroll
    private var transcribedTextArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    // Only show transcribed words when there are any
                    if !transcribedWords.isEmpty {
                        // Animated word display with auto-scroll
                        FlowLayout(spacing: 8) {
                            ForEach(Array(transcribedWords.enumerated()), id: \.offset) { index, word in
                                Text(word)
                                    .font(AppleDesign.Typography.title3)
                                    .foregroundStyle(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                                    .id("word-\(index)")
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                                    .animation(
                                        .spring(response: 0.4, dampingFraction: 0.8)
                                        .delay(Double(index % 5) * 0.02), // Minimal delay
                                        value: transcribedWords.count
                                    )
                            }
                        }
                        .onTapGesture {
                            // Tap on text to edit
                            startTextEditing()
                        }
                        .onChange(of: transcribedWords.count) { _ in
                            // Auto-scroll to bottom
                            if let lastIndex = transcribedWords.indices.last {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    proxy.scrollTo("word-\(lastIndex)", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
            }
            .frame(maxHeight: 200)
        }
    }
    
    
    // MARK: - Actions
    private func handleVoiceButtonTap() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        if isListening {
            stopListening()
        } else if hasError {
            resetErrorState()
            startListening()
        } else {
            startListening()
        }
    }
    
    private func startTextEditing() {
        // Stop listening if active - but don't process the voice command
        if isListening {
            isListening = false
            speechManager.stopRecording()
            
            // Stop listening animations
            withAnimation(.easeInOut(duration: 0.3)) {
                showVoiceAnimation = false
            }
        }
        
        // Convert transcribed words to editable text
        editableText = transcribedWords.joined(separator: " ")
        
        // Switch to editing mode with smooth animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isEditingText = true
        }
        
        // Focus the text field to show keyboard
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isTextFieldFocused = true
        }
    }
    
    private func finishTextEditing() {
        // Only process if text is not empty
        if !editableText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Exit editing mode first
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isEditingText = false
                isTextFieldFocused = false
            }
            
            // Then process the command
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                processVoiceCommand(editableText)
            }
        } else {
            // Just exit editing mode if no text
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isEditingText = false
                isTextFieldFocused = false
            }
        }
    }
    
    private func startListening() {
        hasError = false
        isListening = true
        transcribedWords = []
        
        speechManager.startRecording()
        
        // Start listening animations immediately
        withAnimation(.easeInOut(duration: 0.3)) {
            showVoiceAnimation = true
        }
    }
    
    private func stopListening() {
        isListening = false
        speechManager.stopRecording()
        
        // Stop listening animations
        withAnimation(.easeInOut(duration: 0.3)) {
            showVoiceAnimation = false
        }
        
        // Process the transcribed text
        let finalText = transcribedWords.joined(separator: " ")
        if !finalText.isEmpty {
            processVoiceCommand(finalText)
        }
    }
    
    private func processTranscribedText(_ text: String) {
        let words = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        // Update words efficiently with minimal delay
        if words.count > transcribedWords.count {
            let newWords = Array(words.dropFirst(transcribedWords.count))
            for word in newWords {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    transcribedWords.append(word)
                }
            }
        } else if words.count < transcribedWords.count {
            // Handle backtracking in speech recognition
            transcribedWords = words
        }
    }
    
    private func processVoiceCommand(_ text: String) {
        isProcessing = true
        
        // Call Gemini API
        GeminiService.shared.processTextCommand(text: text, apiKey: geminiAPIKey) { result in
            DispatchQueue.main.async {
                isProcessing = false
                
                switch result {
                case .success(let response):
                    itineraryResponse = response
                    showItinerary = true
                    OmnidimensionService.shared.sendItineraryToReservationAgent(itineraryResponse: response)
                case .failure(let error):
                    handleVoiceError(error)
                }
            }
        }
    }
    
    private func handleVoiceError(_ error: Error) {
        hasError = true
        
        // Haptic feedback for error
        let errorFeedback = UINotificationFeedbackGenerator()
        errorFeedback.notificationOccurred(.error)
    }
    
    private func resetErrorState() {
        hasError = false
        transcribedWords = []
    }
    
    private func closeOverlay() {
        if isListening {
            speechManager.stopRecording()
        }
        
        isPresented = false
    }
    
    
    private func setupSpeechManager() {
        speechManager.requestAuthorization()
    }
}

// MARK: - Supporting Views

struct OrbitalLoadingAnimation: View {
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .fill(.white.opacity(0.8))
                    .frame(width: 12, height: 12)
                    .glassEffect(.regular)
                    .offset(x: 30)
                    .rotationEffect(.degrees(rotationAngle + Double(index * 120)))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.width ?? 0
        var height: CGFloat = 0
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)
            
            if currentRowWidth + subviewSize.width + spacing > containerWidth && currentRowWidth > 0 {
                height += currentRowHeight + spacing
                currentRowWidth = subviewSize.width
                currentRowHeight = subviewSize.height
            } else {
                currentRowWidth += subviewSize.width + (currentRowWidth > 0 ? spacing : 0)
                currentRowHeight = max(currentRowHeight, subviewSize.height)
            }
        }
        
        height += currentRowHeight
        return CGSize(width: containerWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentPosition = CGPoint(x: bounds.minX, y: bounds.minY)
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)
            
            if currentPosition.x + subviewSize.width > bounds.maxX && currentPosition.x > bounds.minX {
                currentPosition.x = bounds.minX
                currentPosition.y += currentRowHeight + spacing
                currentRowHeight = 0
            }
            
            subview.place(
                at: currentPosition,
                anchor: .topLeading,
                proposal: ProposedViewSize(subviewSize)
            )
            
            currentPosition.x += subviewSize.width + spacing
            currentRowHeight = max(currentRowHeight, subviewSize.height)
        }
    }
}

#Preview {
    VoiceGlassOverlay(isPresented: .constant(true))
}
