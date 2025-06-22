//
//  MainView.swift
//  Wandr
//
//  Created by Aryaman Jaiswal on 23/06/25.
//

import SwiftUI
import AVFoundation
import Combine
// Models are imported automatically as they're in the same module

struct MainView: View {
    @State private var currentStatus = "Ready to wander"
    @State private var isRecording = false
    @State private var showItinerary = false
    @State private var itinerary: Itinerary? = nil
    @State private var micScale: CGFloat = 1.0
    @State private var micOpacity: Double = 1.0
    @State private var processingInput = false
    
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
            VoiceInputView(isRecording: $isRecording) {
                // Handle voice input completion
                handleVoiceCompletion()
            }
            
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
    private func handleVoiceCompletion() {
        withAnimation {
            currentStatus = "Creating your perfect adventure..."
            processingInput = true
        }
        
        // Simulate processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            generateSampleItinerary()
            
            withAnimation {
                processingInput = false
                showItinerary = true
                currentStatus = "Ready to wander"
            }
        }
    }
    
    // Generate a sample itinerary
    private func generateSampleItinerary() {
        let itineraryItems = [
            ItineraryItem(
                time: "9:00 AM",
                title: "Anjuna Beach",
                description: "Start your day with the sunrise at this beautiful beach. Great for morning walks and swimming.",
                cost: "Free",
                image: "sunrise.fill"
            ),
            ItineraryItem(
                time: "12:00 PM",
                title: "Lunch at Curlies Beach Shack",
                description: "Enjoy budget-friendly seafood and beer with ocean views. Try their Goan fish curry!",
                cost: "₹500-600 per person",
                image: "fork.knife"
            ),
            ItineraryItem(
                time: "2:00 PM",
                title: "Baga Beach Activities",
                description: "Relax on the beach or try parasailing (optional extra cost).",
                cost: "Free (₹1000 for water sports)",
                image: "beach.umbrella.fill"
            ),
            ItineraryItem(
                time: "5:00 PM",
                title: "Sunset at Thalassa",
                description: "Enjoy the famous sunset with a beer in hand at this Greek-themed restaurant.",
                cost: "₹300-400 per person for drinks",
                image: "sunset.fill"
            ),
            ItineraryItem(
                time: "8:00 PM",
                title: "Dinner at Britto's",
                description: "Popular spot for dinner with live music and great seafood.",
                cost: "₹700-800 per person",
                image: "music.note.list"
            )
        ]
        
        let transportOptions = [
            TransportOption(type: "Rented Scooters", cost: "₹400 per day per scooter (2 people per scooter)", description: "Most flexible option"),
            TransportOption(type: "Taxi", cost: "₹1500-2000 total for the day", description: "Split between 4 people"),
            TransportOption(type: "Local Buses", cost: "₹50-100 per person for the day", description: "Cheapest but less convenient")
        ]
        
        itinerary = Itinerary(
            title: "Goa Beach Day",
            subtitle: "A budget-friendly day of beaches and beer",
            totalCost: "₹3800 per person (approx.)",
            items: itineraryItems,
            transportOptions: transportOptions,
            notes: "Prices are approximate. This itinerary keeps you under your ₹4000 per person budget while hitting the best beach spots in North Goa. The cost includes food, drinks, and transportation via rented scooters."
        )
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

