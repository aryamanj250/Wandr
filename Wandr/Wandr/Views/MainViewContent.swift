//
//  MainViewContent.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI
import Combine

struct MainViewContent: View {
    let onComplete: (String) -> Void
    let onClose: () -> Void
    
    @State private var currentStatus = "Ready to plan your trip"
    @State private var isRecording = false
    @State private var showItinerary = false
    @State private var processingInput = false
    @State private var micScale: CGFloat = 1.0
    @State private var micOpacity: Double = 1.0
    @State private var circleScale: CGFloat = 0.8
    @State private var circleOpacity: Double = 0.2
    @State private var inspirationIndex = 0
    @State private var showInspiration = true
    
    // Inspiration phrases for Goa trip
    private let inspirations = [
        "\"Plan a 4-day Goa trip for me and my 3 friends\"",
        "\"We want beaches, good food, and water sports in Goa\"",
        "\"Find budget-friendly hotels near Baga Beach\"",
        "\"Create a Goa itinerary with nightlife and relaxation\"",
        "\"Book everything for a perfect Goa getaway\""
    ]
    
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Main content
            VStack(spacing: 30) {
                Spacer()
                
                // Animated inspiration text
                if showInspiration {
                    Text(inspirations[inspirationIndex])
                        .font(.custom("Futura", size: 16))
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                        .transition(.opacity)
                        .onReceive(timer) { _ in
                            withAnimation(.easeInOut(duration: 0.8)) {
                                inspirationIndex = (inspirationIndex + 1) % inspirations.count
                            }
                        }
                }
                
                // Voice button area
                voiceInputArea
                
                // Status text
                Text(currentStatus)
                    .font(.custom("Futura", size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                Spacer()
            }
            
            // Voice input overlay
            VoiceInputView(isRecording: $isRecording) {
                handleVoiceCompletion()
            }
            
            // Loading overlay when processing
            if processingInput {
                LoadingOverlay()
                    .transition(.opacity)
            }
        }
        .onAppear {
            animateCircles()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: onClose) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .medium))
                    Text("Close")
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.medium)
                }
                .foregroundStyle(.white)
                .padding(8)
                .padding(.horizontal, 4)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(ScaleButtonStyle())
            
            Spacer()
            
            Text("Ask Alfred")
                .font(.custom("Futura", size: 18))
                .tracking(1)
                .fontWeight(.medium)
                .foregroundStyle(.white)
            
            Spacer()
            
            // Placeholder for symmetry
            Color.clear
                .frame(width: 80)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var voiceInputArea: some View {
        ZStack {
            // Pulsating background circles
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 200, height: 200)
                .scaleEffect(circleScale)
                .opacity(circleOpacity)
            
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 160, height: 160)
                .scaleEffect(circleScale * 1.2)
                .opacity(circleOpacity * 0.8)
            
            // Main voice button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isRecording.toggle()
                    showInspiration = false
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.15), radius: 10, x: 0, y: 0)
                    
                    Image(systemName: "mic.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white)
                }
            }
            .scaleEffect(micScale)
            .opacity(micOpacity)
        }
    }
    
    private func animateCircles() {
        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            circleScale = 1.1
            circleOpacity = 0.4
        }
    }
    
    private func handleVoiceCompletion() {
        withAnimation {
            currentStatus = "Alfred is planning your perfect Goa trip..."
            processingInput = true
        }
        
        // Simulate processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                processingInput = false
                currentStatus = "Ready to plan your trip"
            }
            
            // Call completion with Goa trip response
            onComplete("Plan a 4-day Goa trip for 4 people with beaches and water sports")
        }
    }
}

#Preview {
    MainViewContent(
        onComplete: { response in
            print("Voice response: \(response)")
        },
        onClose: {
            print("Closing voice interface")
        }
    )
    .background(Color.black)
}