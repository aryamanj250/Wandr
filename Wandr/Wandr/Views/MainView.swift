//
//  MainView.swift
//  Wandr
//
//  Created by Aryaman Jaiswal on 23/06/25.
//

import SwiftUI
import AVFoundation
import Combine
import Foundation // For URLSession and other Foundation types
// Models are imported automatically as they're in the same module

struct MainView: View {
    @State private var networkService = NetworkService() // Instantiate NetworkService
    @State private var currentStatus = "Ready to wander"
    @State private var isRecording = false
    @State private var showItinerary = false
    @State private var itinerary: Itinerary? = nil
    @State private var micScale: CGFloat = 1.0
    @State private var micOpacity: Double = 1.0
    @State private var processingInput = false
    @State private var transcribedText: String = "" // Added for VoiceInputView

    // Animation properties
    @State private var circleScale: CGFloat = 0.8
    @State private var circleOpacity: Double = 0.2
    @State private var inspirationIndex = 0
    @State private var showInspiration = true
    
    // Inspiration phrases
    private let inspirations = [
        "\"I'm in San Francisco for a weekend. Love coffee and vintage shops.\"",
        "\"Me and 4 friends want a New York day trip on $100 each.\"",
        "\"Solo traveler in Tokyo for 3 days. First time visitor!\"",
        "\"Looking for indie restaurants in Portland with live music.\"",
        "\"Hiking day trip from Seattle with my dog.\""
    ]
    
    // Timer for cycling inspiration
    let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background with indie pattern
            IndieBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                if showItinerary, let itinerary = itinerary {
                    ItineraryView(itinerary: itinerary, isShowing: $showItinerary)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                } else {
                    // Main voice input area
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
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                            .transition(.opacity)
                            .onReceive(timer) { _ in
                                withAnimation(.easeInOut(duration: 1.0)) {
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
                        .padding(.bottom, 40)
                    
                    Spacer()
                }
            }
            
            // Voice input overlay
            VoiceInputView(text: $transcribedText)
            
            // Loading overlay when processing
            if processingInput {
                LoadingOverlay()
                    .transition(.opacity)
            }
        }
    }
    
    // Header with indie style logo
    private var headerView: some View {
        HStack {
            Text("wandr")
                .font(.custom("Futura", size: 24))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .tracking(1)
                .padding(.leading)
            
            Spacer()
            
            if showItinerary == false && itinerary != nil {
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        showItinerary = true
                    }
                }) {
                    HStack(spacing: 4) {
                        Text("Last trip")
                            .font(.custom("Futura", size: 14))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(.white)
                    .padding(8)
                    .padding(.horizontal, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.trailing)
                }
            }
        }
        .frame(height: 60)
        .background(Color.black.opacity(0.3))
    }
    
    // Voice input button area with animations
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
        }
        .onAppear {
            animateCircles()
        }
    }
    
    // Animate the background circles
    private func animateCircles() {
        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            circleScale = 1.1
            circleOpacity = 0.4
        }
    }
    
    // Handle voice input completion
    private func handleVoiceCompletion(transcribedText: String) {
        print("Transcribed text: \(transcribedText)")
        withAnimation {
            currentStatus = "Creating your perfect adventure..."
            processingInput = true
        }

        networkService.sendTextCommand(text: transcribedText) { result in
            switch result {
            case .success(let taskId):
                DispatchQueue.main.async { [self] in
                    print("Task initiated with ID: \(taskId)")
                    self.pollForCommandResult(taskId: taskId)
                }
            case .failure(let error):
                DispatchQueue.main.async { [self] in
                    print("Error initiating command: \(error.localizedDescription)")
                    withAnimation {
                        self.currentStatus = "Error: \(error.localizedDescription)"
                        self.processingInput = false
                    }
                }
            }
        }
    }

    private func pollForCommandResult(taskId: String) {
        let pollInterval: TimeInterval = 1.0 // Poll every 1 second
        let maxAttempts = 60 // Max 60 attempts (60 seconds)
        var attempts = 0

        func poll() {
            guard attempts < maxAttempts else {
                DispatchQueue.main.async { [self] in
                    withAnimation {
                        self.currentStatus = "Error: Processing timed out."
                        self.processingInput = false
                    }
                }
                return
            }

            attempts += 1
            networkService.getCommandResult(taskId: taskId) { result in
                switch result {
                case .success(let commandResult):
                    DispatchQueue.main.async { [self] in
                        switch commandResult.status {
                        case "pending", "processing":
                            // Continue polling
                            DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval) { [self] in
                                poll()
                            }
                        case "completed":
                            print("Command completed. Result: \(String(describing: commandResult.result))")
                            if let geminiResult = commandResult.result {
                                // Assuming GeminiResult can be mapped to Itinerary
                                // This part needs refinement based on actual Gemini output structure
                                // Map GeminiResult to Itinerary
                                let title = geminiResult.location.map { "Trip to \($0)" } ?? "Generated Trip"
                                let subtitle = geminiResult.preferences?.joined(separator: ", ") ?? "Your personalized adventure awaits!"
                                let totalCost = geminiResult.budget.map { "Budget: ₹\(Int($0))" } ?? "Budget: N/A"
                                let notes = geminiResult.special_requirements ?? "No detailed notes provided."

                                self.itinerary = Itinerary(
                                    title: title,
                                    subtitle: subtitle,
                                    totalCost: totalCost,
                                    items: [], // Gemini currently doesn't provide detailed items
                                    transportOptions: [], // Gemini currently doesn't provide transport options
                                    notes: notes
                                )
                                withAnimation {
                                    self.processingInput = false
                                    self.showItinerary = true
                                    self.currentStatus = "Ready to wander"
                                }
                            } else {
                                withAnimation {
                                    self.currentStatus = "Error: No result from Gemini."
                                    self.processingInput = false
                                }
                            }
                        case "failed":
                            print("Command failed. Error: \(String(describing: commandResult.error))")
                            withAnimation {
                                self.currentStatus = "Error: \(commandResult.error ?? "Unknown error")"
                                self.processingInput = false
                            }
                        default:
                            print("Unknown task status: \(commandResult.status)")
                            DispatchQueue.main.asyncAfter(deadline: .now() + pollInterval) { [self] in
                                poll()
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async { [self] in
                        print("Error getting command result: \(error.localizedDescription)")
                        withAnimation {
                            self.currentStatus = "Error: \(error.localizedDescription)"
                            self.processingInput = false
                        }
                    }
                }
            }
        }
        poll() // Start polling
    }
}

// Indie-style background
struct IndieBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            // Simple gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black, 
                    Color.black.opacity(0.95)
                ]),
                startPoint: animateGradient ? .topLeading : .bottomLeading,
                endPoint: animateGradient ? .bottomTrailing : .topTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
