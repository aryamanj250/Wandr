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
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Header with live indicator
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
                
                // Current status
                VStack(spacing: 12) {
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
                    
                    if let nextAction = trip.progress.nextAction {
                        HStack {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.orange)
                            
                            Text("Next: \(nextAction)")
                                .font(.custom("Futura", size: 14))
                                .foregroundStyle(.white.opacity(0.8))
                            
                            Spacer()
                        }
                    }
                }
                
                // Quick actions
                HStack(spacing: 12) {
                    QuickActionButton(icon: "phone.fill", title: "Call Hotel", color: .green)
                    QuickActionButton(icon: "car.fill", title: "Book Ride", color: .blue)
                    QuickActionButton(icon: "map.fill", title: "Navigate", color: .orange)
                    
                    Spacer()
                    
                    Text("Ends \(formatReturnDate())")
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.6))
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
                currentTask: "Monitoring Delhi weather for next 24 hours",
                lastUpdate: "2 minutes ago",
                progress: 0.8
            ),
            AgentActivity(
                agentType: .traffic,
                status: .active,
                currentTask: "Tracking traffic to Red Fort - suggesting optimal route",
                lastUpdate: "30 seconds ago",
                progress: 0.9
            ),
            AgentActivity(
                agentType: .restaurant,
                status: .waiting,
                currentTask: "Confirmed Karim's reservation - awaiting your arrival",
                lastUpdate: "10 minutes ago",
                progress: 1.0
            )
        ]
    }
}

// MARK: - Trip with Agent Status (for upcoming trips)
struct TripWithAgentStatus: View {
    let trip: UpcomingTrip
    
    var body: some View {
        VStack(spacing: 16) {
            // Trip header
            VStack(alignment: .leading, spacing: 8) {
                Text(trip.destination)
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text("\(trip.companions) people • \(trip.duration)")
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                
                if let budget = trip.budget {
                    Text(budget)
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.green)
                }
            }
            
            // Agent status
            VStack(spacing: 8) {
                HStack {
                    Text("Agent Status")
                        .font(.custom("Futura", size: 12))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.8))
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    AgentStatusDot(type: .booking, status: .active)
                    AgentStatusDot(type: .weather, status: .standby)
                    AgentStatusDot(type: .restaurant, status: .standby)
                    Spacer()
                }
            }
            
            // Progress
            VStack(spacing: 8) {
                HStack {
                    Text("Planning Progress")
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                    Spacer()
                    Text("\(Int(trip.progress.progressPercentage * 100))%")
                        .font(.custom("Futura", size: 12))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
                
                ProgressView(value: trip.progress.progressPercentage)
                    .tint(.orange)
                    .scaleEffect(y: 1.5)
            }
        }
        .padding(16)
        .frame(width: 280)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }
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