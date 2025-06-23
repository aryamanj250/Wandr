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
    @State private var showAlfredAction = false
    @State private var currentAlfredAction: AlfredAction?
    @State private var butlerGreeting = ""
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
                VStack(spacing: 20) {
                    // Butler greeting section
                    butlerGreetingSection
                        .padding(.top, 20)
                    
                    // Current trip progress (prominent)
                    currentTripSection
                    
                    // Glass voice button
                    glassVoiceButton
                        .padding(.vertical, 10)
                    
                    // Quick actions
                    quickActionsSection
                    
                    // Ongoing tasks
                    ongoingTasksSection
                    
                    // Upcoming trips
                    upcomingTripsSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            
            // Voice interface overlay
            if showVoiceInterface {
                voiceInterfaceOverlay
            }
            
            // Alfred action overlay
            if showAlfredAction, let action = currentAlfredAction {
                AlfredActionView(action: action, isShowing: $showAlfredAction)
            }
        }
        .onAppear {
            generateButlerGreeting()
        }
        .onReceive(timer) { _ in
            currentTime = Date()
            generateButlerGreeting()
        }
    }
    
    // MARK: - Butler Greeting Section
    private var butlerGreetingSection: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(timeBasedGreeting())
                        .font(.custom("Futura", size: 28))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text(butlerGreeting)
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Butler avatar
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "person.fill.badge.plus")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
            }
            
            // Current time and weather placeholder
            HStack {
                Label(formatCurrentTime(), systemImage: "clock")
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
                
                Label("22°C Partly Cloudy", systemImage: "cloud.sun")
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Current Trip Section
    private var currentTripSection: some View {
        VStack(spacing: 16) {
            // Section header
            HStack {
                Text("Trip Updates")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                Button(action: {}) {
                    Text("View All")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            // Current trip card
            if let currentTrip = sampleCurrentTrip {
                CurrentTripCard(trip: currentTrip) {
                    // Show trip details
                }
            }
            
            // Next trip preview
            if let nextTrip = sampleTrips.first {
                NextTripPreview(trip: nextTrip) {
                    // Plan trip action
                    planGoaTrip()
                }
            }
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
                            
                            Text("Ask Alfred")
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
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.custom("Futura", size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 5)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                ForEach(sampleQuickActions) { action in
                    QuickActionCard(action: action)
                }
            }
        }
    }
    
    // MARK: - Ongoing Tasks Section
    private var ongoingTasksSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Ongoing Tasks")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(sampleTasks.count) active")
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal, 5)
            
            LazyVStack(spacing: 12) {
                ForEach(sampleTasks.prefix(3)) { task in
                    TaskCard(task: task)
                }
            }
        }
    }
    
    // MARK: - Upcoming Trips Section
    private var upcomingTripsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Upcoming Adventures")
                .font(.custom("Futura", size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(sampleTrips) { trip in
                        TripCard(trip: trip)
                    }
                }
                .padding(.horizontal, 5)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func timeBasedGreeting() -> String {
        let timeOfDay = TimeOfDay.current()
        switch timeOfDay {
        case .morning: return "Good Morning"
        case .afternoon: return "Good Afternoon"
        case .evening: return "Good Evening"
        case .night: return "Good Evening"
        }
    }
    
    private func generateButlerGreeting() {
        let greetings = [
            "Ready to assist with your day",
            "How may I help you today?",
            "At your service for another adventure",
            "What shall we plan today?",
            "Your personal travel assistant is ready"
        ]
        
        butlerGreeting = greetings.randomElement() ?? greetings[0]
    }
    
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
        // Process voice response and show Alfred action
        if response.lowercased().contains("goa") || response.lowercased().contains("trip") {
            planGoaTrip()
        }
        
        withAnimation(.easeOut(duration: 0.3)) {
            showVoiceInterface = false
            resetVoiceButton()
        }
    }
    
    private func planGoaTrip() {
        let action = AlfredAction(
            title: "Planning Your Goa Trip",
            description: "Setting up a 4-day trip to Goa for 4 people",
            status: .inProgress,
            progress: 0.3,
            estimatedTime: "2-3 minutes",
            steps: [
                ActionStep(title: "Searching flights", description: "Finding best flight options from Delhi to Goa", isCompleted: true, isActive: false, duration: "30s"),
                ActionStep(title: "Comparing hotels", description: "Analyzing 50+ hotels based on your preferences", isCompleted: true, isActive: false, duration: "45s"),
                ActionStep(title: "Booking recommendations", description: "Preparing personalized recommendations", isCompleted: false, isActive: true, duration: "60s"),
                ActionStep(title: "Creating itinerary", description: "Building day-by-day activities", isCompleted: false, isActive: false, duration: "45s"),
                ActionStep(title: "Final review", description: "Preparing options for your approval", isCompleted: false, isActive: false, duration: "30s")
            ],
            result: nil
        )
        
        currentAlfredAction = action
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showAlfredAction = true
        }
    }
}

// MARK: - Supporting Views and Models

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
    var sampleQuickActions: [QuickAction] {
        [
            QuickAction(title: "Weather", subtitle: "Partly Cloudy, 22°C", icon: "cloud.sun", action: .weather, value: "22°C"),
            QuickAction(title: "Calendar", subtitle: "3 events today", icon: "calendar", action: .calendar, value: "3"),
            QuickAction(title: "Traffic", subtitle: "Light traffic", icon: "car.fill", action: .traffic, value: "Light"),
            QuickAction(title: "Reminders", subtitle: "2 pending", icon: "bell.fill", action: .reminders, value: "2")
        ]
    }
    
    var sampleTasks: [ButlerTask] {
        [
            ButlerTask(
                title: "Get taxi to restaurant",
                description: "Book ride to La Bernardin for 8:00 PM reservation",
                priority: .high,
                dueTime: "7:30 PM",
                category: .transport,
                actionable: true,
                icon: "car.fill",
                estimatedDuration: "5 min"
            ),
            ButlerTask(
                title: "Check-in reminder",
                description: "Flight check-in opens in 2 hours",
                priority: .medium,
                dueTime: "6:00 PM",
                category: .travel,
                actionable: true,
                icon: "airplane",
                estimatedDuration: "2 min"
            ),
            ButlerTask(
                title: "Pack essentials",
                description: "Don't forget charger and travel documents",
                priority: .medium,
                dueTime: "Tomorrow",
                category: .reminder,
                actionable: false,
                icon: "suitcase.fill",
                estimatedDuration: "15 min"
            )
        ]
    }
    
    var sampleCurrentTrip: UpcomingTrip? {
        UpcomingTrip(
            destination: "Delhi, India",
            departureDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            returnDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
            duration: "3 days",
            status: .inProgress,
            imageUrl: nil,
            budget: "₹15,000",
            companions: 1,
            participants: ["You", "Sarah"],
            progress: TripProgress(
                totalSteps: 8,
                completedSteps: 6,
                currentAction: "Enjoying Red Fort visit",
                nextAction: "Dinner at Karim's",
                estimatedCompletion: "Tomorrow 6 PM"
            ),
            bookings: TripBookings(
                flights: FlightBooking(
                    airline: "IndiGo",
                    flightNumber: "6E 142",
                    departure: FlightSegment(airport: "Mumbai Airport", airportCode: "BOM", time: Date(), terminal: "T2"),
                    arrival: FlightSegment(airport: "Delhi Airport", airportCode: "DEL", time: Date(), terminal: "T3"),
                    price: "₹4,500",
                    status: .confirmed,
                    bookingReference: "ABC123"
                ),
                hotels: [],
                selectedHotel: nil,
                transport: [],
                activities: []
            ),
            notes: "Having an amazing time exploring Delhi's historical sites!"
        )
    }
    
    var sampleTrips: [UpcomingTrip] {
        [
            UpcomingTrip(
                destination: "Goa, India",
                departureDate: Calendar.current.date(byAdding: .day, value: 12, to: Date()) ?? Date(),
                returnDate: Calendar.current.date(byAdding: .day, value: 16, to: Date()) ?? Date(),
                duration: "4 days",
                status: .planning,
                imageUrl: nil,
                budget: "₹25,000 per person",
                companions: 4,
                participants: ["You", "Rahul", "Priya", "Amit"],
                progress: TripProgress(
                    totalSteps: 6,
                    completedSteps: 0,
                    currentAction: nil,
                    nextAction: "Start planning",
                    estimatedCompletion: "Plan ready in 3 minutes"
                ),
                bookings: TripBookings(
                    flights: nil,
                    hotels: [],
                    selectedHotel: nil,
                    transport: [],
                    activities: []
                ),
                notes: "Beach relaxation with friends - looking for beachfront hotels and water sports"
            ),
            UpcomingTrip(
                destination: "Tokyo, Japan",
                departureDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
                returnDate: Calendar.current.date(byAdding: .day, value: 52, to: Date()) ?? Date(),
                duration: "7 days",
                status: .confirmed,
                imageUrl: nil,
                budget: "$2,500",
                companions: 1,
                participants: ["You", "Emma"],
                progress: TripProgress(
                    totalSteps: 10,
                    completedSteps: 8,
                    currentAction: "All bookings confirmed",
                    nextAction: "Prepare for trip",
                    estimatedCompletion: "Ready to go!"
                ),
                bookings: TripBookings(flights: nil, hotels: [], selectedHotel: nil, transport: [], activities: []),
                notes: nil
            )
        ]
    }
}

#Preview {
    HomeView()
}
