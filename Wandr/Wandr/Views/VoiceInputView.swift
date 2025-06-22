//
//  VoiceInputView.swift
//  Wandr
//
//  Created by Aryaman Jaiswal on 23/06/25.
//

import SwiftUI

struct VoiceInputView: View {
    @Binding var isRecording: Bool
    let onFinish: () -> Void
    
    // Animation properties
    @State private var waveHeight1: CGFloat = 0
    @State private var waveHeight2: CGFloat = 0
    @State private var waveHeight3: CGFloat = 0
    @State private var waveHeight4: CGFloat = 0
    @State private var waveHeight5: CGFloat = 0
    @State private var waveHeight6: CGFloat = 0
    @State private var waveHeight7: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.95
    @State private var ringScale: CGFloat = 1.0
    @State private var ringOpacity: Double = 0.0
    
    // Recording timing
    @State private var recordingTimer: Timer?
    @State private var recordingDuration: Double = 0
    @State private var isAnimating = false
    
    private let maxRecordingTime: Double = 15.0
    
    var body: some View {
        ZStack {
            // Background
            backgroundView
            
            // Main content
            mainContentView
        }
        .opacity(isRecording ? 1 : 0)
        .onChange(of: isRecording) { newValue in
            if newValue {
                startRecording()
            } else {
                stopRecording()
            }
        }
    }
    
    // MARK: - View Components
    
    private var backgroundView: some View {
        Group {
            if isRecording {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .opacity(opacity)
            }
        }
    }
    
    private var mainContentView: some View {
        VStack(spacing: 20) {
            if isRecording {
                listeningTextView
            }
            
            // Recording indicator
            recordingIndicatorView
            
            // Timer text
            timerView
            
            // Action buttons
            actionButtonsView
        }
    }
    
    private var listeningTextView: some View {
        Text("listening...")
            .font(.custom("Futura", size: 28))
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .tracking(2)
            .opacity(opacity * 0.9)
    }
    
    private var recordingIndicatorView: some View {
        ZStack {
            // Main button background
            Circle()
                .fill(Color.black)
                .frame(width: 90, height: 90)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: .white.opacity(0.2), radius: 15, x: 0, y: 0)
            
            // Sound waves
            soundWavesView
            
            // Microphone icon
            Image(systemName: "mic.fill")
                .font(.system(size: 28))
                .foregroundStyle(Color.white.opacity(0.7))
                .opacity(isAnimating ? 0 : 1)
        }
        .scaleEffect(scale)
    }
    
    private var soundWavesView: some View {
        HStack(spacing: 4) {
            soundWave(height: waveHeight1)
            soundWave(height: waveHeight2)
            soundWave(height: waveHeight3)
            soundWave(height: waveHeight4)
            soundWave(height: waveHeight5)
            soundWave(height: waveHeight6)
            soundWave(height: waveHeight7)
        }
        .opacity(isAnimating ? 1 : 0)
    }
    
    private var timerView: some View {
        Text(timeFormatted)
            .font(.custom("Futura", size: 16))
            .foregroundStyle(.white.opacity(0.9))
            .padding(.top, 10)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
            )
    }
    
    private var actionButtonsView: some View {
        HStack(spacing: 60) {
            // Cancel button
            Button(action: {
                cancelRecording()
            }) {
                Text("Cancel")
                    .font(.custom("Futura", size: 16))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
            
            // Done button
            Button(action: {
                finishRecording()
            }) {
                Text("Done")
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 0)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .opacity(opacity)
    }
    
    // Single sound wave bar with rounded corners
    private func soundWave(height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.white.opacity(0.9))
            .frame(width: 3, height: max(4, height))
    }
    
    // Recording timer formatted as MM:SS
    private var timeFormatted: String {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Initialize recording state and animations
    private func startRecording() {
        withAnimation(.easeIn(duration: 0.4)) {
            opacity = 1.0
            scale = 1.0
            ringScale = 1.0
            ringOpacity = 0.7
        }
        
        // Start wave animation after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimating = true
            animateWaves()
        }
        
        // Start recording timer
        recordingDuration = 0
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            recordingDuration += 1
            
            // Automatically stop after max time
            if recordingDuration >= maxRecordingTime {
                finishRecording()
            }
        }
    }
    
    // Animate sound waves with random heights
    private func animateWaves() {
        let baseAnimation = Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true)
        
        withAnimation(baseAnimation) {
            waveHeight1 = CGFloat.random(in: 10...40)
        }
        
        withAnimation(baseAnimation.delay(0.1)) {
            waveHeight2 = CGFloat.random(in: 15...50)
        }
        
        withAnimation(baseAnimation.delay(0.2)) {
            waveHeight3 = CGFloat.random(in: 20...60)
        }
        
        withAnimation(baseAnimation.delay(0.15)) {
            waveHeight4 = CGFloat.random(in: 15...50)
        }
        
        withAnimation(baseAnimation.delay(0.05)) {
            waveHeight5 = CGFloat.random(in: 10...40)
        }
        
        withAnimation(baseAnimation.delay(0.25)) {
            waveHeight6 = CGFloat.random(in: 8...45)
        }
        
        withAnimation(baseAnimation.delay(0.18)) {
            waveHeight7 = CGFloat.random(in: 12...35)
        }
    }
    
    // Cancel recording
    private func cancelRecording() {
        withAnimation(.easeOut(duration: 0.3)) {
            scale = 0.9
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            cleanupRecording()
            isRecording = false
        }
    }
    
    // Finish recording and call completion handler
    private func finishRecording() {
        withAnimation(.easeOut(duration: 0.3)) {
            scale = 1.2
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            cleanupRecording()
            isRecording = false
            onFinish()
        }
    }
    
    // Stop recording animations and cleanup
    private func stopRecording() {
        cleanupRecording()
    }
    
    // Clean up animation state and timers
    private func cleanupRecording() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        recordingDuration = 0
        isAnimating = false
        waveHeight1 = 0
        waveHeight2 = 0
        waveHeight3 = 0
        waveHeight4 = 0
        waveHeight5 = 0
        waveHeight6 = 0
        waveHeight7 = 0
    }
}

#Preview {
    VoiceInputView(isRecording: .constant(true), onFinish: {})
        .preferredColorScheme(.dark)
} 
