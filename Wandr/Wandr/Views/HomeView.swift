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
    @State private var showPreferencesSelection = false
    @State private var voiceInputResult: VoiceInputResult?
    @State private var upcomingTrips: [UpcomingTrip] = []
    @State private var currentTime = Date()
    @State private var voiceButtonScale: CGFloat = 1.0
    @State private var glassOpacity: Double = 1.0
    @State private var showVoiceAnimation = false

    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Background
            ButlerBackground()
                .edgesIgnoringSafeArea(.all)

            // Main content
            ScrollView {
                VStack(spacing: 30) {
                    // App title
                    appTitleSection
                        .padding(.top, 20)

                    // Voice prompt and button at top
                    VStack(spacing: 16) {
                        Text("Ready to plan your next trip?")
                            .font(.custom("Futura", size: 18))
                            .fontWeight(.medium)
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)

                        // Glass voice button
                        glassVoiceButton
                    }
                    .padding(.vertical, 20)

                    // Current trip with live agent activities
                    if let currentTrip = sampleCurrentTrip {
                        currentTripWithAgents(currentTrip)
                    }

                    // Only show upcoming trips after voice planning creates them
                    if !upcomingTrips.isEmpty {
                        upcomingTripsSection
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }

            // Voice interface overlay
            if showVoiceInterface {
                voiceInterfaceOverlay
            }

            // Preferences selection overlay
            if showPreferencesSelection, let voiceResult = voiceInputResult {
                NavigationView {
                    AnimatedPreferencesView(
                        voiceResult: voiceResult,
                        onComplete: { preferences in
                            handlePreferencesComplete(preferences)
                        }
                    )
                }
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            currentTime = Date()
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }

    // MARK: - App Title Section
    private var appTitleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Wandr")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Spacer()
            }

            HStack {
                Text("AI Travel Concierge")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))

                Spacer()
            }
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Current Trip with Agent Activities
    private func currentTripWithAgents(_ trip: UpcomingTrip) -> some View {
        VStack(spacing: 20) {
            // Section header
            HStack {
                Text("Live Trip")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Spacer()

                // Live indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(.green.opacity(0.3), lineWidth: 2)
                                .scaleEffect(1.5)
                        )

                    Text("AGENTS ACTIVE")
                        .font(.custom("Futura", size: 10))
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .tracking(1)
                }
            }

            // Enhanced current trip card with agent activities
            NavigationLink(destination: TripDetailView(trip: trip)) {
                CurrentTripWithAgents(trip: trip) {
                    // Navigation handled by NavigationLink
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    // MARK: - Voice Interface Overlay
    private var voiceInterfaceOverlay: some View {
        ZStack {
            // Blur background
            Color.black.opacity(0.4)
                .background(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showVoiceInterface = false
                        resetVoiceButton()
                    }
                }

            // Voice interface
            VStack(spacing: 0) {
                Spacer()

                // Close handle
                RoundedRectangle(cornerRadius: 3)
                    .fill(.white.opacity(0.3))
                    .frame(width: 40, height: 6)
                    .padding(.bottom, 20)

                // Voice interface content
                MainViewContent(onComplete: { response in
                    handleVoiceResponse(response)
                }, onClose: {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showVoiceInterface = false
                        resetVoiceButton()
                    }
                })
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.black.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 16)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.8)
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        ))
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
        .buttonStyle(ScaleButtonStyle())
    }



    // MARK: - Upcoming Trips Section
    private var upcomingTripsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Planned Trips")
                .font(.custom("Futura", size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(upcomingTrips) { trip in
                        TripWithAgentStatus(trip: trip)
                    }
                }
                .padding(.horizontal, 5)
            }
        }
    }

    // MARK: - Helper Functions


    private func formatCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: currentTime)
    }

    private func resetVoiceButton() {
        showVoiceAnimation = false
        voiceButtonScale = 1.0
        glassOpacity = 1.0
    }

    private func handleVoiceResponse(_ response: String) {
        // Parse voice input and extract trip details
        let voiceResult = parseVoiceInput(response)

        withAnimation(.easeOut(duration: 0.3)) {
            showVoiceInterface = false
            resetVoiceButton()
        }

        // Show preferences selection after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            voiceInputResult = voiceResult
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showPreferencesSelection = true
            }
        }
    }

    private func parseVoiceInput(_ input: String) -> VoiceInputResult {
        // Enhanced parsing for demo scenarios
        let lowercased = input.lowercased()

        var destination = "Unknown Destination"
        var duration = 3
        var companions = 2
        var isGoaDemo = false

        // Check for Goa demo scenario
        if lowercased.contains("goa") && lowercased.contains("airport") && lowercased.contains("5k") {
            destination = "Goa Offbeat Adventure"
            duration = 1 // Same day trip
            companions = 2
            isGoaDemo = true
        } else if lowercased.contains("goa") {
            destination = "Goa, India"
        } else if lowercased.contains("delhi") {
            destination = "Delhi, India"
        } else if lowercased.contains("mumbai") {
            destination = "Mumbai, India"
        } else if lowercased.contains("tokyo") {
            destination = "Tokyo, Japan"
        } else if lowercased.contains("paris") {
            destination = "Paris, France"
        } else if lowercased.contains("london") {
            destination = "London, UK"
        }

        // Extract duration (if not Goa demo)
        if !isGoaDemo {
            if lowercased.contains("week") {
                duration = 7
            } else if lowercased.contains("weekend") {
                duration = 2
            } else if lowercased.contains("4 day") || lowercased.contains("four day") {
                duration = 4
            } else if lowercased.contains("5 day") || lowercased.contains("five day") {
                duration = 5
            }
        }

        // Extract companions
        if lowercased.contains("solo") || lowercased.contains("alone") {
            companions = 1
        } else if lowercased.contains("couple") || lowercased.contains("two") {
            companions = 2
        } else if lowercased.contains("me and my friend") {
            companions = 2
        } else if lowercased.contains("4 people") || lowercased.contains("four people") {
            companions = 4
        } else if lowercased.contains("friends") {
            companions = 4
        }

        return VoiceInputResult(
            destination: destination,
            duration: duration,
            companions: companions,
            originalInput: input
        )
    }

    private func handlePreferencesComplete(_ preferences: TravelPreferences) {
        withAnimation(.easeOut(duration: 0.3)) {
            showPreferencesSelection = false
        }

        // Create new trip from preferences
        let isGoaTrip = preferences.destination.contains("Goa") && preferences.destination.contains("Offbeat")

        let newTrip = UpcomingTrip(
            destination: preferences.destination,
            departureDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date(),
            returnDate: isGoaTrip ? Calendar.current.date(byAdding: .hour, value: 10, to: Date()) ?? Date() : Calendar.current.date(byAdding: .day, value: preferences.duration, to: Date()) ?? Date(),
            duration: isGoaTrip ? "Same day trip" : "\(preferences.duration) days",
            status: .planning,
            imageUrl: nil,
            budget: isGoaTrip ? "₹5,000" : preferences.budget.displayName,
            companions: preferences.companions,
            participants: generateParticipantNames(count: preferences.companions),
            progress: TripProgress(
                totalSteps: isGoaTrip ? 8 : 10,
                completedSteps: isGoaTrip ? 3 : 0,
                currentAction: nil,
                nextAction: isGoaTrip ? "3 agents finding offbeat spots and deals" : "Agents deploying to start planning",
                estimatedCompletion: isGoaTrip ? "Complete plan ready in 20 minutes" : "Basic plan ready in 3 minutes"
            ),
            bookings: TripBookings(flights: nil, hotels: [], selectedHotel: nil, transport: [], activities: []),
            notes: isGoaTrip ? "Budget-conscious offbeat adventure with beer experiences" : "AI agents working on \(preferences.activityPreferences.map { $0.rawValue }.joined(separator: ", ")) experiences"
        )

        // Add to upcoming trips
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            upcomingTrips.append(newTrip)
        }
    }

    private func generateParticipantNames(count: Int) -> [String] {
        let names = ["You", "Friend", "Sarah", "Mike", "Priya", "Alex", "Emma", "Rahul"]
        return Array(names.prefix(count))
    }

}

// MARK: - Supporting Views and Models

// Voice Input Result
struct VoiceInputResult {
    let destination: String
    let duration: Int
    let companions: Int
    let originalInput: String
}

// Butler Background
struct ButlerBackground: View {
    @State private var animateGradient = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.black.opacity(0.95),
                    Color.black.opacity(0.9)
                ]),
                startPoint: animateGradient ? .topLeading : .bottomLeading,
                endPoint: animateGradient ? .bottomTrailing : .topTrailing
            )
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }

            // Subtle pattern overlay
            Circle()
                .fill(.white.opacity(0.02))
                .frame(width: 300, height: 300)
                .blur(radius: 100)
                .offset(x: 100, y: -200)
        }
    }
}


// Sample Data
extension HomeView {

    var sampleCurrentTrip: UpcomingTrip? {
        UpcomingTrip(
            destination: "Delhi Heritage Tour",
            departureDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            returnDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
            duration: "3 days",
            status: .inProgress,
            imageUrl: nil,
            budget: "₹15,000 (₹13,200 spent)",
            companions: 2,
            participants: ["You", "Sarah"],
            progress: TripProgress(
                totalSteps: 10,
                completedSteps: 8,
                currentAction: "Preparing for Red Fort visit",
                nextAction: "Red Fort exploration at 3:00 PM",
                estimatedCompletion: "Day 3 of 3 - Final day"
            ),
            bookings: TripBookings(
                flights: FlightBooking(
                    airline: "IndiGo",
                    flightNumber: "6E 142",
                    departure: FlightSegment(airport: "Mumbai Airport", airportCode: "BOM", time: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), terminal: "T2"),
                    arrival: FlightSegment(airport: "Delhi Airport", airportCode: "DEL", time: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), terminal: "T3"),
                    price: "₹4,500",
                    status: .confirmed,
                    bookingReference: "ABC123"
                ),
                hotels: [],
                selectedHotel: nil,
                transport: [],
                activities: []
            ),
            notes: "Day 3 of 3 - All planning complete, only monitoring agents active"
        )
    }

    var sampleTrips: [UpcomingTrip] {
        // Initially empty - trips will be added after voice planning
        []
    }
}

#Preview {
    HomeView()
}
