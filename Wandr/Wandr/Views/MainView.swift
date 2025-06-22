//
//  MainView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI
import AVFoundation
// Models are imported automatically as they're in the same module

struct MainView: View {
    @State private var inputText = ""
    @State private var messages: [Message] = []
    @State private var isRecording = false
    @State private var showItinerary = false
    @State private var itinerary: Itinerary? = nil
    @State private var micScale: CGFloat = 1.0
    @State private var micOpacity: Double = 1.0
    @State private var isTyping = false
    @State private var processingInput = false
    @State private var showingWelcome = true
    
    // Animation properties
    @State private var welcomeOpacity = 0.0
    @State private var welcomeOffset: CGFloat = 50
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                if showItinerary, let itinerary = itinerary {
                    ItineraryView(itinerary: itinerary, isShowing: $showItinerary)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                } else {
                    // Messages area
                    ScrollViewReader { scrollView in
                        ScrollView {
                            VStack(spacing: 24) {
                                if showingWelcome {
                                    welcomeMessageView
                                        .opacity(welcomeOpacity)
                                        .offset(y: welcomeOffset)
                                        .onAppear {
                                            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                                                welcomeOpacity = 1.0
                                                welcomeOffset = 0
                                            }
                                        }
                                }
                                
                                ForEach(messages) { message in
                                    MessageView(message: message)
                                        .id(message.id)
                                }
                                
                                if isTyping {
                                    TypingIndicator()
                                        .id("typingIndicator")
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        }
                        .onChange(of: messages.count) {
                            withAnimation {
                                if let lastMessage = messages.last {
                                    scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: isTyping) {
                            if isTyping {
                                withAnimation {
                                    scrollView.scrollTo("typingIndicator", anchor: .bottom)
                                }
                            }
                        }
                    }
                    .background(Color.black)
                    
                    // Input area
                    inputView
                }
            }
            
            // Voice input overlay
            VoiceInputView(isRecording: $isRecording) {
                // Handle voice input completion
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    inputText = "Me and my 3 friends are in Goa for 1 day. We want beaches and beer, but we're broke - max ₹4000 per person."
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        sendMessage()
                    }
                }
            }
            
            // Loading overlay when processing
            if processingInput {
                LoadingOverlay()
                    .transition(.opacity)
            }
        }
    }
    
    // Header view with animated logo
    private var headerView: some View {
        HStack {
            Text("wandr")
                .font(.custom("Futura", size: 24))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .tracking(1)
                .padding(.leading)
            
            Spacer()
            
            if showItinerary == false {
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        // Show sample itinerary if needed
                        if itinerary == nil {
                            generateSampleItinerary()
                        }
                        showItinerary = true
                    }
                }) {
                    Image(systemName: "map")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding()
                        .opacity(messages.isEmpty ? 0.4 : 1.0)
                }
                .disabled(messages.isEmpty)
            }
        }
        .frame(height: 60)
        .background(Color.black)
    }
    
    // Welcome message with Alfred's introduction
    private var welcomeMessageView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text("A")
                            .font(.custom("Futura", size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Alfred")
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text("Hello, I'm Alfred, your travel butler. Tell me about your trip idea, including your location, budget, group size, and the vibe you're looking for. I'll create the perfect itinerary for you.")
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.white)
                        .lineSpacing(4)
                }
                .padding(.trailing, 16)
            }
            
            Text("Example: \"Me and my 3 friends are in Goa for 1 day. We want beaches and beer, but we're broke - max ₹4000 per person.\"")
                .font(.custom("Futura", size: 14))
                .italic()
                .foregroundStyle(.white.opacity(0.6))
                .padding(12)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
    
    // Custom input area with animated microphone button
    private var inputView: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.white.opacity(0.2))
            
            HStack(spacing: 16) {
                if !isRecording {
                    TextField("Tell Alfred your travel plans...", text: $inputText)
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(24)
                        .submitLabel(.send)
                        .onSubmit {
                            sendMessage()
                        }
                } else {
                    Text("Listening...")
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(24)
                }
                
                Button(action: {
                    if inputText.isEmpty {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isRecording.toggle()
                        }
                    } else {
                        sendMessage()
                    }
                }) {
                    Image(systemName: inputText.isEmpty ? "mic.fill" : "arrow.up.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(isRecording ? Color.red : Color.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.black)
        }
    }
    
    // Function to send a message
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = Message(id: UUID().uuidString, text: inputText, isUser: true, timestamp: Date())
        withAnimation {
            messages.append(userMessage)
            inputText = ""
            showingWelcome = false
            isTyping = true
        }
        
        // Simulate Alfred's response
        processingInput = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            simulateAlfredResponse(to: userMessage.text)
            processingInput = false
            isTyping = false
        }
    }
    
    // Simulate Alfred's response
    private func simulateAlfredResponse(to userPrompt: String) {
        let response = "I've crafted a perfect day in Goa for you and your friends that fits your ₹4000 per person budget. Your itinerary includes Anjuna Beach, Curlies Beach Shack for lunch, an afternoon at Baga Beach, sunset drinks at Thalassa, and dinner at Britto's. I've included transport options and pricing details. Would you like to see the full itinerary?"
        
        let alfredMessage = Message(id: UUID().uuidString, text: response, isUser: false, timestamp: Date())
        withAnimation {
            messages.append(alfredMessage)
        }
        
        // Generate a sample itinerary
        generateSampleItinerary()
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

// Message bubble view
struct MessageView: View {
    let message: Message
    @State private var opacity = 0.0
    @State private var offset: CGFloat = 30
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if !message.isUser {
                Circle()
                    .fill(Color.white)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text("A")
                            .font(.custom("Futura", size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    )
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.isUser ? "You" : "Alfred")
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
                
                Text(message.text)
                    .font(.custom("Futura", size: 16))
                    .foregroundStyle(.white)
                    .lineSpacing(4)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        message.isUser ?
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.1)) :
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.05))
                    )
                    .cornerRadius(20)
                    .frame(maxWidth: 300, alignment: message.isUser ? .trailing : .leading)
            }
            .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
            
            if message.isUser {
                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text("You")
                            .font(.custom("Futura", size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                    )
            }
        }
        .opacity(opacity)
        .offset(y: offset)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1)) {
                opacity = 1.0
                offset = 0
            }
        }
    }
}

// Typing indicator animation
struct TypingIndicator: View {
    @State private var firstDotScale: CGFloat = 1.0
    @State private var secondDotScale: CGFloat = 1.0
    @State private var thirdDotScale: CGFloat = 1.0
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.white)
                .frame(width: 36, height: 36)
                .overlay(
                    Text("A")
                        .font(.custom("Futura", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                )
            
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 8, height: 8)
                    .scaleEffect(firstDotScale)
                
                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 8, height: 8)
                    .scaleEffect(secondDotScale)
                
                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 8, height: 8)
                    .scaleEffect(thirdDotScale)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
            )
        }
        .onAppear {
            animateDots()
        }
    }
    
    // Animated typing indicator
    private func animateDots() {
        let animation = Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true)
        
        withAnimation(animation.delay(0)) {
            firstDotScale = 1.3
        }
        
        withAnimation(animation.delay(0.2)) {
            secondDotScale = 1.3
        }
        
        withAnimation(animation.delay(0.4)) {
            thirdDotScale = 1.3
        }
    }
}

#Preview {
    MainView()
} 