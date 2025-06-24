//
//  CurrentTripCard.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct CurrentTripCard: View {
    let trip: UpcomingTrip
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        AppleCard(
            padding: AppleDesign.Spacing.cardPadding,
            cornerRadius: AppleDesign.CornerRadius.card,
            shadowStyle: AppleDesign.Shadows.medium
        ) {
            VStack(spacing: AppleDesign.Spacing.md) {
                // Header with live indicator
                HStack {
                    VStack(alignment: .leading, spacing: AppleDesign.Spacing.xs) {
                        StatusIndicator(
                            status: .active,
                            text: "LIVE",
                            showPulse: true
                        )

                        Text(trip.destination)
                            .font(AppleDesign.Typography.cardTitle)
                            .foregroundStyle(AppleDesign.Colors.textPrimary)

                        Text("Day \(dayNumber) of \(trip.duration)")
                            .font(AppleDesign.Typography.cardSubtitle)
                            .foregroundStyle(AppleDesign.Colors.textSecondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: AppleDesign.Spacing.xs) {
                        Text("Progress")
                            .font(AppleDesign.Typography.caption2)
                            .foregroundStyle(AppleDesign.Colors.textTertiary)

                        Text("\(Int(trip.progress.progressPercentage * 100))%")
                            .font(AppleDesign.Typography.title3)
                            .foregroundStyle(AppleDesign.Colors.textPrimary)
                    }
                }

                // Enhanced progress bar
                VStack(spacing: AppleDesign.Spacing.xs) {
                    ProgressView(value: trip.progress.progressPercentage)
                        .tint(AppleDesign.Colors.info)
                        .scaleEffect(y: 1.5)
                        .background(AppleDesign.Colors.surfaceElevated)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .animation(AppleAnimations.gentleSpring, value: trip.progress.progressPercentage)
                }

                // Current status with better spacing
                VStack(spacing: AppleDesign.Spacing.sm) {
                    if let currentAction = trip.progress.currentAction {
                        StatusRow(
                            icon: "location.fill",
                            iconColor: AppleDesign.Colors.info,
                            label: "Now",
                            text: currentAction
                        )
                    }

                    if let nextAction = trip.progress.nextAction {
                        StatusRow(
                            icon: "clock.fill",
                            iconColor: AppleDesign.Colors.warning,
                            label: "Next",
                            text: nextAction
                        )
                    }
                }

                // Enhanced quick actions
                HStack(spacing: AppleDesign.Spacing.sm) {
                    EnhancedQuickActionButton(
                        icon: "phone.fill",
                        title: "Call Hotel",
                        color: AppleDesign.Colors.success
                    )
                    
                    EnhancedQuickActionButton(
                        icon: "car.fill",
                        title: "Book Ride",
                        color: AppleDesign.Colors.info
                    )
                    
                    EnhancedQuickActionButton(
                        icon: "map.fill",
                        title: "Navigate",
                        color: AppleDesign.Colors.warning
                    )

                    Spacer()

                    Text("Ends \(formatReturnDate())")
                        .font(AppleDesign.Typography.caption2)
                        .foregroundStyle(AppleDesign.Colors.textTertiary)
                }
            }
        }
        .appleCardPress(action: action)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(AppleAnimations.gentleSpring, value: isPressed)
    }

    private var dayNumber: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: trip.departureDate, to: Date()).day ?? 0
        return max(1, days + 1)
    }

    private func formatReturnDate() -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current

        if calendar.isDateInToday(trip.returnDate) {
            return "today"
        } else if calendar.isDateInTomorrow(trip.returnDate) {
            return "tomorrow"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: trip.returnDate)
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(color)
            }

            Text(title)
                .font(.custom("Futura", size: 10))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
}

struct NextTripPreview: View {
    let trip: UpcomingTrip
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Trip info
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("NEXT")
                            .font(.custom("Futura", size: 10))
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                            .tracking(1)

                        Spacer()

                        Text(daysUntilTrip())
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.white.opacity(0.6))
                    }

                    Text(trip.destination)
                        .font(.custom("Futura", size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Text("\(trip.companions) people • \(trip.duration)")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))

                    if let budget = trip.budget {
                        Text(budget)
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.green)
                    }
                }

                Spacer()

                // Action button
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(.orange.opacity(0.2))
                            .frame(width: 50, height: 50)

                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.orange)
                    }

                    Text("Plan Trip")
                        .font(.custom("Futura", size: 11))
                        .foregroundStyle(.orange)
                        .fontWeight(.medium)
                }
            }
            .padding(16)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.orange.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func daysUntilTrip() -> String {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: trip.departureDate).day ?? 0

        if days == 0 {
            return "Departing today"
        } else if days == 1 {
            return "Departing tomorrow"
        } else {
            return "In \(days) days"
        }
    }
}

// MARK: - Current Trip with Live Agent Activities
struct CurrentTripWithAgents: View {
    let trip: UpcomingTrip
    let action: () -> Void
    @State private var agentActivities: [AgentActivity] = []

    var body: some View {
        Button(action: action) {
            VStack(spacing: 20) {
                // Trip header with live status
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(.green)
                                .frame(width: 8, height: 8)
                                .overlay(
                                    Circle()
                                        .stroke(.green.opacity(0.3), lineWidth: 2)
                                        .scaleEffect(1.5)
                                )

                            Text("LIVE")
                                .font(.custom("Futura", size: 10))
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                                .tracking(1)
                        }

                        Text(trip.destination)
                            .font(.custom("Futura", size: 22))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("Day \(dayNumber) of \(trip.duration)")
                            .font(.custom("Futura", size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Progress")
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.white.opacity(0.6))

                        Text("\(Int(trip.progress.progressPercentage * 100))%")
                            .font(.custom("Futura", size: 18))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                }

                // Progress bar
                ProgressView(value: trip.progress.progressPercentage)
                    .tint(.blue)
                    .scaleEffect(y: 2)
                    .background(.white.opacity(0.1))

                // Live agent activities
                VStack(spacing: 12) {
                    HStack {
                        Text("AI Agents Active")
                            .font(.custom("Futura", size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(agentActivities.count) active")
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.white.opacity(0.6))
                    }

                    VStack(spacing: 8) {
                        ForEach(agentActivities) { activity in
                            AgentActivityRow(activity: activity)
                        }
                    }
                }

                // Current status
                if let currentAction = trip.progress.currentAction {
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)

                        Text("Now: \(currentAction)")
                            .font(.custom("Futura", size: 14))
                            .foregroundStyle(.white)

                        Spacer()
                    }
                }
            }
            .padding(20)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .blue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .onAppear {
            loadAgentActivities()
        }
    }

    private var dayNumber: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: trip.departureDate, to: Date()).day ?? 0
        return max(1, days + 1)
    }

    private func loadAgentActivities() {
        agentActivities = [
            AgentActivity(
                agentType: .weather,
                status: .active,
                currentTask: "Clear skies detected - perfect for Red Fort photos",
                lastUpdate: "1 minute ago",
                progress: 1.0
            ),
            AgentActivity(
                agentType: .traffic,
                status: .active,
                currentTask: "Suggesting 2:30 PM departure to avoid traffic",
                lastUpdate: "30 seconds ago",
                progress: 1.0
            ),
            AgentActivity(
                agentType: .booking,
                status: .completed,
                currentTask: "All reservations confirmed (Karim's, Red Fort, transport)",
                lastUpdate: "2 days ago",
                progress: 1.0
            ),
            AgentActivity(
                agentType: .activity,
                status: .completed,
                currentTask: "All tickets secured and activities planned",
                lastUpdate: "2 days ago",
                progress: 1.0
            )
        ]
    }
}

// MARK: - Trip with Agent Status (for upcoming trips)
struct TripWithAgentStatus: View {
    let trip: UpcomingTrip

    var body: some View {
        NavigationLink(destination: GoaTripDetailView(trip: trip)) {
            VStack(spacing: 16) {
                // Trip header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(trip.destination)
                            .font(.custom("Futura", size: 18))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .lineLimit(1)

                        Spacer()

                        // Status indicator
                        HStack(spacing: 4) {
                            Circle()
                                .fill(statusColor)
                                .frame(width: 8, height: 8)

                            Text(statusText)
                                .font(.custom("Futura", size: 10))
                                .fontWeight(.medium)
                                .foregroundStyle(statusColor)
                        }
                    }

                    Text("\(trip.companions) people • Airport by 12 PM")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))

                    if isGoaTrip {
                        Text("₹5,000 budget • Offbeat + Beer")
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.green)
                    } else if let budget = trip.budget {
                        Text(budget)
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.green)
                    }
                }

                // Agent activity summary
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 12))
                            .foregroundStyle(.blue)

                        Text("\(activeAgentsCount) agents active")
                            .font(.custom("Futura", size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)

                        Spacer()

                        Text(currentAgentActivity)
                            .font(.custom("Futura", size: 10))
                            .foregroundStyle(.white.opacity(0.6))
                            .lineLimit(1)
                    }

                    // Progress bar
                    VStack(spacing: 4) {
                        HStack {
                            Text("Planning Progress")
                                .font(.custom("Futura", size: 11))
                                .foregroundStyle(.white.opacity(0.6))
                            Spacer()
                            Text("\(Int(trip.progress.progressPercentage * 100))%")
                                .font(.custom("Futura", size: 11))
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }

                        ProgressView(value: trip.progress.progressPercentage)
                            .tint(.orange)
                            .scaleEffect(y: 1.2)
                    }
                }

                // Quick agent status
                HStack(spacing: 8) {
                    ForEach(agentSummary, id: \.type) { agent in
                        AgentMiniStatus(agent: agent)
                    }

                    Spacer()

                    // Tap indicator
                    Text("Tap for details")
                        .font(.custom("Futura", size: 9))
                        .foregroundStyle(.blue.opacity(0.7))
                }
            }
            .padding(16)
            .frame(width: 300)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.orange.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var isGoaTrip: Bool {
        trip.destination.contains("Goa") && trip.destination.contains("Offbeat")
    }

    private var statusColor: Color {
        switch trip.status {
        case .planning: return .orange
        case .booked: return .yellow
        case .confirmed: return .green
        case .inProgress: return .blue
        }
    }

    private var statusText: String {
        switch trip.status {
        case .planning: return "PLANNING"
        case .booked: return "BOOKED"
        case .confirmed: return "READY"
        case .inProgress: return "LIVE"
        }
    }

    private var activeAgentsCount: Int {
        if isGoaTrip {
            return 3 // Location, Weather, Budget agents active
        }
        return 2
    }

    private var currentAgentActivity: String {
        if isGoaTrip {
            return "Finding hidden spots..."
        }
        return "Working on reservations..."
    }

    private var agentSummary: [AgentSummary] {
        if isGoaTrip {
            return [
                AgentSummary(type: .activity, status: .active, task: "Finding offbeat places"),
                AgentSummary(type: .weather, status: .active, task: "Monitoring conditions"),
                AgentSummary(type: .transport, status: .active, task: "Route planning"),
                AgentSummary(type: .booking, status: .standby, task: "Ready for reservations")
            ]
        } else {
            return [
                AgentSummary(type: .booking, status: .active, task: "Making reservations"),
                AgentSummary(type: .weather, status: .standby, task: "Monitoring"),
                AgentSummary(type: .transport, status: .standby, task: "Planning routes")
            ]
        }
    }
}

// MARK: - Supporting Mini Components
struct AgentMiniStatus: View {
    let agent: AgentSummary

    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .fill(agent.status.color.opacity(0.2))
                    .frame(width: 16, height: 16)

                Image(systemName: agent.type.icon)
                    .font(.system(size: 8))
                    .foregroundStyle(agent.status.color)
            }

            Text(agent.type.shortName)
                .font(.custom("Futura", size: 7))
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}

struct AgentSummary {
    let type: AgentType
    let status: AgentStatus
    let task: String
}

// MARK: - Supporting Views
struct AgentActivityRow: View {
    let activity: AgentActivity

    var body: some View {
        HStack(spacing: 12) {
            // Agent type icon
            ZStack {
                Circle()
                    .fill(activity.agentType.color.opacity(0.2))
                    .frame(width: 32, height: 32)

                Image(systemName: activity.agentType.icon)
                    .font(.system(size: 14))
                    .foregroundStyle(activity.agentType.color)
            }

            // Activity details
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.currentTask)
                    .font(.custom("Futura", size: 13))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(activity.lastUpdate)
                    .font(.custom("Futura", size: 11))
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            // Status indicator
            Circle()
                .fill(activity.status.color)
                .frame(width: 8, height: 8)
        }
    }
}

struct AgentStatusDot: View {
    let type: AgentType
    let status: AgentStatus

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(status.color.opacity(0.2))
                    .frame(width: 24, height: 24)

                Image(systemName: type.icon)
                    .font(.system(size: 10))
                    .foregroundStyle(status.color)
            }

            Text(type.shortName)
                .font(.custom("Futura", size: 8))
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}

// MARK: - Enhanced Components for Apple Design
struct StatusRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let text: String
    
    var body: some View {
        HStack(spacing: AppleDesign.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(width: 20)
            
            Text("\(label):")
                .font(AppleDesign.Typography.caption1)
                .foregroundStyle(AppleDesign.Colors.textTertiary)
            
            Text(text)
                .font(AppleDesign.Typography.footnote)
                .foregroundStyle(AppleDesign.Colors.textSecondary)
                .lineLimit(2)
            
            Spacer()
        }
    }
}

struct EnhancedQuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: AppleDesign.Spacing.xs) {
            ZStack {
                Circle()
                    .fill(color.opacity(isPressed ? 0.3 : 0.2))
                    .frame(width: 40, height: 40)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(color)
            }
            
            Text(title)
                .font(AppleDesign.Typography.caption2)
                .foregroundStyle(AppleDesign.Colors.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(AppleAnimations.buttonTap) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    VStack(spacing: 20) {
        CurrentTripWithAgents(trip: UpcomingTrip(
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
            bookings: TripBookings(flights: nil, hotels: [], selectedHotel: nil, transport: [], activities: []),
            notes: "Having an amazing time!"
        )) {}
    }
    .padding()
    .background(Color.black)
}
