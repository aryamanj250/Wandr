//
//  GoaTripDetailView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct GoaTripDetailView: View {
    let trip: UpcomingTrip
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: GoaTripTab = .timeline
    @State private var agentUpdates: [AgentUpdate] = []

    var body: some View {
        ZStack {
            // Background
            ButlerBackground()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Tab selector
                tabSelector

                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        // Trip header
                        tripHeader

                        // Content based on selected tab
                        switch selectedTab {
                        case .timeline:
                            timelineContent
                        case .agents:
                            agentsContent
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationTitle("Goa Adventure")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundStyle(.white)
            }
        }
        .onAppear {
            loadAgentUpdates()
        }
    }

    // MARK: - Trip Header
    private var tripHeader: some View {
        VStack(spacing: 16) {
            // Main trip info
            VStack(spacing: 8) {
                HStack {
                    Text(trip.destination)
                        .font(.custom("Futura", size: 24))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Spacer()

                    // Status indicator
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.orange)
                            .frame(width: 8, height: 8)

                        Text("PLANNING")
                            .font(.custom("Futura", size: 10))
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                            .tracking(1)
                    }
                }

                HStack(spacing: 16) {
                    Label("2 people", systemImage: "person.3.fill")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))

                    Label("Airport by 12 PM", systemImage: "airplane")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))

                    Label("₹5,000 budget", systemImage: "indianrupeesign.circle")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.green)
                }
            }

            // Progress section
            VStack(spacing: 12) {
                HStack {
                    Text("Planning Progress")
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Spacer()

                    Text("\(Int(trip.progress.progressPercentage * 100))% Complete")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.8))
                }

                ProgressView(value: trip.progress.progressPercentage)
                    .tint(.orange)
                    .scaleEffect(y: 2)
                    .background(.white.opacity(0.1))
            }

            // Agent status summary
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 14))
                    .foregroundStyle(.blue)

                Text("3 agents actively working")
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.blue)

                Spacer()

                Text("Last update: 30s ago")
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Timeline Content
    private var timelineContent: some View {
        VStack(spacing: 20) {
            // Confirmed items (next 3-4)
            VStack(alignment: .leading, spacing: 16) {
                Text("Confirmed Activities")
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                VStack(spacing: 12) {
                    ForEach(confirmedItems) { item in
                        ConfirmedTimelineItem(item: item)
                    }
                }
            }

            // Agent working section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Agents Planning Remaining Activities")
                        .font(.custom("Futura", size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Spacer()

                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 6, height: 6)

                        Text("Live")
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.green)
                    }
                }

                VStack(spacing: 12) {
                    ForEach(pendingItems) { item in
                        PendingTimelineItem(item: item)
                    }
                }
            }
        }
    }

    // MARK: - Agents Content
    private var agentsContent: some View {
        VStack(spacing: 20) {
            // Active agents
            VStack(alignment: .leading, spacing: 16) {
                Text("Active Agents")
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                VStack(spacing: 12) {
                    ForEach(activeAgents) { agent in
                        ActiveAgentCard(agent: agent)
                    }
                }
            }

            // Standby agents
            VStack(alignment: .leading, spacing: 16) {
                Text("Standby Agents")
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                VStack(spacing: 12) {
                    ForEach(standbyAgents) { agent in
                        StandbyAgentCard(agent: agent)
                    }
                }
            }

            // Recent updates
            if !agentUpdates.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Agent Updates")
                        .font(.custom("Futura", size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    VStack(spacing: 8) {
                        ForEach(agentUpdates.prefix(5)) { update in
                            AgentUpdateRow(update: update)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(GoaTripTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 16))

                        Text(tab.title)
                            .font(.custom("Futura", size: 12))
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(selectedTab == tab ? .white : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        selectedTab == tab ?
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            ) : nil
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            Rectangle()
                .fill(.black.opacity(0.3))
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundStyle(.white.opacity(0.1)),
                    alignment: .bottom
                )
        )
    }

    // MARK: - Data Loading
    private func loadAgentUpdates() {
        agentUpdates = [
            AgentUpdate(
                id: UUID(),
                agentType: .activity,
                message: "Found 3 hidden beaches not in tourist guides",
                timestamp: Date().addingTimeInterval(-30),
                priority: .high
            ),
            AgentUpdate(
                id: UUID(),
                agentType: .transport,
                message: "Scooter rental for ₹300/day confirmed at pickup location",
                timestamp: Date().addingTimeInterval(-120),
                priority: .medium
            ),
            AgentUpdate(
                id: UUID(),
                agentType: .weather,
                message: "Clear skies expected until 3 PM, perfect for beach hopping",
                timestamp: Date().addingTimeInterval(-180),
                priority: .low
            ),
            AgentUpdate(
                id: UUID(),
                agentType: .budget,
                message: "Local feni tasting found for ₹200 vs ₹500 at tourist spots",
                timestamp: Date().addingTimeInterval(-240),
                priority: .medium
            )
        ]
    }

    // MARK: - Sample Data
    private var confirmedItems: [GoaTimelineItem] {
        [
            GoaTimelineItem(
                id: UUID(),
                time: "Now",
                title: "Scooter Pickup",
                description: "Pick up pre-booked scooter",
                location: "Anjuna Beach Road",
                cost: "₹300",
                status: .confirmed,
                agentNote: "Confirmed by Transport Agent"
            ),
            GoaTimelineItem(
                id: UUID(),
                time: "10:30 AM",
                title: "Ashwem Beach",
                description: "Hidden gem with minimal crowds",
                location: "North Goa",
                cost: "Free entry",
                status: .confirmed,
                agentNote: "Local Agent confirmed low crowds"
            ),
            GoaTimelineItem(
                id: UUID(),
                time: "11:30 AM",
                title: "Coffee at Artjuna",
                description: "Offbeat café with local vibes",
                location: "Anjuna",
                cost: "₹400 for 2",
                status: .confirmed,
                agentNote: "Reservation confirmed"
            )
        ]
    }

    private var pendingItems: [GoaTimelineItem] {
        [
            GoaTimelineItem(
                id: UUID(),
                time: "12:30 PM",
                title: "Local Feni Tasting",
                description: "Authentic cashew wine experience",
                location: "TBD",
                cost: "₹200-300",
                status: .pending,
                agentNote: "Budget Agent finding best deals"
            ),
            GoaTimelineItem(
                id: UUID(),
                time: "2:00 PM",
                title: "Secret Beach Spot",
                description: "Off-the-map location",
                location: "TBD",
                cost: "Free",
                status: .pending,
                agentNote: "Location Agent verifying accessibility"
            ),
            GoaTimelineItem(
                id: UUID(),
                time: "10:00 AM",
                title: "Airport Departure",
                description: "Return scooter and head to airport",
                location: "Goa Airport",
                cost: "₹200 taxi",
                status: .pending,
                agentNote: "Transport Agent optimizing route"
            )
        ]
    }

    private var activeAgents: [GoaAgent] {
        [
            GoaAgent(
                id: UUID(),
                type: .activity,
                status: .active,
                currentTask: "Researching 2 more offbeat spots within budget",
                progress: 0.7,
                lastUpdate: "30 seconds ago",
                priority: .high
            ),
            GoaAgent(
                id: UUID(),
                type: .transport,
                status: .active,
                currentTask: "Optimizing routes to ensure 12 PM airport arrival",
                progress: 0.8,
                lastUpdate: "1 minute ago",
                priority: .high
            ),
            GoaAgent(
                id: UUID(),
                type: .budget,
                status: .active,
                currentTask: "Finding group discounts and local deals",
                progress: 0.6,
                lastUpdate: "2 minutes ago",
                priority: .medium
            )
        ]
    }

    private var standbyAgents: [GoaAgent] {
        [
            GoaAgent(
                id: UUID(),
                type: .weather,
                status: .standby,
                currentTask: "Monitoring conditions for activity adjustments",
                progress: 1.0,
                lastUpdate: "5 minutes ago",
                priority: .low
            ),
            GoaAgent(
                id: UUID(),
                type: .booking,
                status: .standby,
                currentTask: "Ready to make reservations once spots are confirmed",
                progress: 0.0,
                lastUpdate: "15 minutes ago",
                priority: .low
            )
        ]
    }
}

// MARK: - Supporting Views

struct ConfirmedTimelineItem: View {
    let item: GoaTimelineItem

    var body: some View {
        HStack(spacing: 12) {
            // Timeline indicator
            VStack {
                Circle()
                    .fill(.green)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 2)
                    )

                Rectangle()
                    .fill(.green.opacity(0.3))
                    .frame(width: 2, height: 30)
            }

            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.time)
                        .font(.custom("Futura", size: 12))
                        .fontWeight(.bold)
                        .foregroundStyle(.green)

                    Spacer()

                    Text(item.cost)
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Text(item.title)
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Text(item.description)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.8))

                if !item.agentNote.isEmpty {
                    Text(item.agentNote)
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.green.opacity(0.8))
                        .italic()
                }
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.green.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.green.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct PendingTimelineItem: View {
    let item: GoaTimelineItem

    var body: some View {
        HStack(spacing: 12) {
            // Timeline indicator
            VStack {
                Circle()
                    .fill(.orange)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 2)
                    )
                    .overlay(
                        // Pulsing animation
                        Circle()
                            .stroke(.orange.opacity(0.4), lineWidth: 3)
                            .scaleEffect(1.5)
                            .opacity(0.7)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: true)
                    )

                Rectangle()
                    .fill(.orange.opacity(0.3))
                    .frame(width: 2, height: 30)
            }

            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.time)
                        .font(.custom("Futura", size: 12))
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)

                    Spacer()

                    Text(item.cost)
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Text(item.title)
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Text(item.description)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.8))

                HStack(spacing: 4) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 10))
                        .foregroundStyle(.orange)

                    Text(item.agentNote)
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.orange)
                        .italic()
                }
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.orange.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.orange.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct ActiveAgentCard: View {
    let agent: GoaAgent

    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(agent.type.color.opacity(0.2))
                            .frame(width: 32, height: 32)

                        Image(systemName: agent.type.icon)
                            .font(.system(size: 14))
                            .foregroundStyle(agent.type.color)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(agent.type.displayName) Agent")
                            .font(.custom("Futura", size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)

                        Text(agent.lastUpdate)
                            .font(.custom("Futura", size: 11))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }

                Spacer()

                HStack(spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)

                    Text("ACTIVE")
                        .font(.custom("Futura", size: 10))
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }

            // Current task
            Text(agent.currentTask)
                .font(.custom("Futura", size: 14))
                .foregroundStyle(.white.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Progress
            VStack(spacing: 4) {
                HStack {
                    Text("Progress")
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.6))

                    Spacer()

                    Text("\(Int(agent.progress * 100))%")
                        .font(.custom("Futura", size: 12))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }

                ProgressView(value: agent.progress)
                    .tint(agent.type.color)
                    .scaleEffect(y: 1.2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.green.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct StandbyAgentCard: View {
    let agent: GoaAgent

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 32, height: 32)

                Image(systemName: agent.type.icon)
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.6))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(agent.type.displayName) Agent")
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)

                Text(agent.currentTask)
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(2)
            }

            Spacer()

            Text("STANDBY")
                .font(.custom("Futura", size: 9))
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.5))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.white.opacity(0.1))
                )
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct AgentUpdateRow: View {
    let update: AgentUpdate

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(update.agentType.color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(update.message)
                    .font(.custom("Futura", size: 13))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text("\(update.agentType.displayName) • \(timeAgo(update.timestamp))")
                    .font(.custom("Futura", size: 11))
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }

    private func timeAgo(_ date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 {
            return "\(seconds)s ago"
        } else if seconds < 3600 {
            return "\(seconds / 60)m ago"
        } else {
            return "\(seconds / 3600)h ago"
        }
    }
}

// MARK: - Supporting Models

enum GoaTripTab: String, CaseIterable {
    case timeline = "Timeline"
    case agents = "Agents"

    var title: String { rawValue }

    var icon: String {
        switch self {
        case .timeline: return "clock.fill"
        case .agents: return "brain.head.profile"
        }
    }
}

struct GoaTimelineItem: Identifiable {
    let id: UUID
    let time: String
    let title: String
    let description: String
    let location: String
    let cost: String
    let status: TimelineItemStatus
    let agentNote: String
}

enum TimelineItemStatus {
    case confirmed
    case pending
}

struct GoaAgent: Identifiable {
    let id: UUID
    let type: GoaAgentType
    let status: AgentStatus
    let currentTask: String
    let progress: Double
    let lastUpdate: String
    let priority: AgentPriority
}

enum GoaAgentType {
    case activity
    case transport
    case budget
    case weather
    case booking

    var displayName: String {
        switch self {
        case .activity: return "Location"
        case .transport: return "Transport"
        case .budget: return "Budget"
        case .weather: return "Weather"
        case .booking: return "Booking"
        }
    }

    var icon: String {
        switch self {
        case .activity: return "star.fill"
        case .transport: return "car.fill"
        case .budget: return "indianrupeesign.circle.fill"
        case .weather: return "cloud.sun.fill"
        case .booking: return "phone.fill"
        }
    }

    var color: Color {
        switch self {
        case .activity: return .orange
        case .transport: return .green
        case .budget: return .blue
        case .weather: return .cyan
        case .booking: return .purple
        }
    }
}

struct AgentUpdate: Identifiable {
    let id: UUID
    let agentType: GoaAgentType
    let message: String
    let timestamp: Date
    let priority: AgentPriority
}

enum AgentPriority {
    case low, medium, high
}

#Preview {
    NavigationView {
        GoaTripDetailView(trip: UpcomingTrip(
            destination: "Goa Offbeat Adventure",
            departureDate: Date(),
            returnDate: Date(),
            duration: "1 day",
            status: .planning,
            imageUrl: nil,
            budget: "₹5,000",
            companions: 2,
            participants: ["You", "Friend"],
            progress: TripProgress(
                totalSteps: 8,
                completedSteps: 3,
                currentAction: nil,
                nextAction: "Agents finding hidden spots",
                estimatedCompletion: "Plan ready in 20 minutes"
            ),
            bookings: TripBookings(flights: nil, hotels: [], selectedHotel: nil, transport: [], activities: []),
            notes: "Offbeat adventure with beer and budget constraints"
        ))
    }
}
