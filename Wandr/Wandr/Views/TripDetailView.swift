//
//  TripDetailView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct TripDetailView: View {
    let trip: UpcomingTrip
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: TripDetailTab = .timeline
    
    var body: some View {
        ZStack {
            // Background
            ButlerBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Tab selector (fixed)
                tabSelector
                
                // Scrollable content including header
                ScrollView {
                    VStack(spacing: 20) {
                        // Header (now scrollable)
                        tripHeader
                        
                        // Content
                        switch selectedTab {
                        case .timeline:
                            timelineContent
                        case .agents:
                            agentContent
                        case .budget:
                            budgetContent
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundStyle(.white)
            }
        }
    }
    
    private var tripHeader: some View {
        VStack(spacing: 16) {
            // Trip title and status
            VStack(spacing: 8) {
                Text(trip.destination)
                    .font(.custom("Futura", size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                HStack(spacing: 16) {
                    Label("Day 3 of 3", systemImage: "calendar")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Label("\(trip.companions) people", systemImage: "person.3.fill")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Label(trip.budget ?? "Budget not set", systemImage: "creditcard")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            // Progress and status
            VStack(spacing: 12) {
                HStack {
                    Text("Overall Progress")
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("\(Int(trip.progress.progressPercentage * 100))% Complete")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                ProgressView(value: trip.progress.progressPercentage)
                    .tint(.blue)
                    .scaleEffect(y: 2)
                    .background(.white.opacity(0.1))
                
                // Live status
                HStack(spacing: 8) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(.green.opacity(0.3), lineWidth: 2)
                                .scaleEffect(1.5)
                        )
                    
                    Text("2 monitoring agents active")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.green)
                    
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(TripDetailTab.allCases, id: \.self) { tab in
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
    
    // MARK: - Timeline Content
    private var timelineContent: some View {
        VStack(spacing: 20) {
            // Today's timeline
            timelineSection(
                title: "Today - Day 3 (Final Day)",
                items: todayTimelineItems
            )
            
            // Yesterday
            timelineSection(
                title: "Yesterday - Day 2",
                items: yesterdayTimelineItems
            )
            
            // Day 1
            timelineSection(
                title: "Day 1",
                items: day1TimelineItems
            )
            
            // Tomorrow (departure)
            timelineSection(
                title: "Tomorrow - Departure",
                items: tomorrowTimelineItems
            )
        }
    }
    
    private func timelineSection(title: String, items: [TimelineItem]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom("Futura", size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                ForEach(items) { item in
                    TimelineItemRow(item: item)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Agent Content
    private var agentContent: some View {
        VStack(spacing: 20) {
            // Active agents
            agentSection(
                title: "Currently Active",
                agents: activeAgentHistory,
                color: .green
            )
            
            // Completed agents
            agentSection(
                title: "Completed Work",
                agents: completedAgentHistory,
                color: .blue
            )
            
            // Agent communication log
            communicationLogSection
        }
    }
    
    private func agentSection(title: String, agents: [AgentHistory], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(agents.count) agents")
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                ForEach(agents) { agent in
                    AgentHistoryRow(agent: agent)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var communicationLogSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Agent Communication Log")
                .font(.custom("Futura", size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            VStack(spacing: 8) {
                ForEach(communicationLog) { log in
                    CommunicationLogRow(log: log)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.purple.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Budget Content
    private var budgetContent: some View {
        VStack(spacing: 20) {
            // Budget overview
            budgetOverviewSection
            
            // Spending breakdown
            spendingBreakdownSection
            
            // Agent savings
            agentSavingsSection
        }
    }
    
    private var budgetOverviewSection: some View {
        VStack(spacing: 16) {
            Text("Budget Overview")
                .font(.custom("Futura", size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Budget")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                    Text("₹15,000")
                        .font(.custom("Futura", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Spent")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                    Text("₹13,200")
                        .font(.custom("Futura", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Remaining")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                    Text("₹1,800")
                        .font(.custom("Futura", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }
            
            ProgressView(value: 13200, total: 15000)
                .tint(.orange)
                .scaleEffect(y: 2)
                .background(.white.opacity(0.1))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var spendingBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Spending Breakdown")
                .font(.custom("Futura", size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                ForEach(spendingCategories) { category in
                    SpendingCategoryRow(category: category)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var agentSavingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Agent-Found Savings")
                .font(.custom("Futura", size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            VStack(spacing: 8) {
                ForEach(agentSavings) { saving in
                    AgentSavingRow(saving: saving)
                }
            }
            
            HStack {
                Text("Total Saved by Agents")
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("₹2,300")
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
            }
            .padding(.top, 8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.white.opacity(0.2)),
                alignment: .top
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.green.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.green.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Supporting Models and Views

enum TripDetailTab: String, CaseIterable {
    case timeline = "Timeline"
    case agents = "Agents"  
    case budget = "Budget"
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .timeline: return "clock.fill"
        case .agents: return "brain.head.profile"
        case .budget: return "creditcard.fill"
        }
    }
}

struct TimelineItem: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let description: String
    let status: TimelineStatus
    let notes: String?
}

enum TimelineStatus {
    case completed
    case current
    case pending
    case cancelled
    
    var color: Color {
        switch self {
        case .completed: return .green
        case .current: return .blue
        case .pending: return .orange
        case .cancelled: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .completed: return "checkmark.circle.fill"
        case .current: return "clock.badge.fill"
        case .pending: return "clock"
        case .cancelled: return "xmark.circle.fill"
        }
    }
}

struct AgentHistory: Identifiable {
    let id = UUID()
    let agentType: AgentType
    let completedDate: String
    let tasksCompleted: Int
    let totalTasks: Int
    let summary: String
}

struct CommunicationLog: Identifiable {
    let id = UUID()
    let timestamp: String
    let agentType: AgentType
    let action: String
    let result: String
}

struct SpendingCategory: Identifiable {
    let id = UUID()
    let name: String
    let amount: Int
    let icon: String
    let color: Color
}

struct AgentSaving: Identifiable {
    let id = UUID()
    let agentType: AgentType
    let description: String
    let amountSaved: Int
}

struct TimelineItemRow: View {
    let item: TimelineItem
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Image(systemName: item.status.icon)
                .font(.system(size: 16))
                .foregroundStyle(item.status.color)
                .frame(width: 20)
            
            // Time
            Text(item.time)
                .font(.custom("Futura", size: 12))
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 60, alignment: .leading)
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Text(item.description)
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.7))
                
                if let notes = item.notes {
                    Text(notes)
                        .font(.custom("Futura", size: 11))
                        .foregroundStyle(.white.opacity(0.5))
                        .italic()
                }
            }
            
            Spacer()
        }
    }
}

struct AgentHistoryRow: View {
    let agent: AgentHistory
    
    var body: some View {
        HStack(spacing: 12) {
            // Agent icon
            ZStack {
                Circle()
                    .fill(agent.agentType.color.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: agent.agentType.icon)
                    .font(.system(size: 14))
                    .foregroundStyle(agent.agentType.color)
            }
            
            // Agent details
            VStack(alignment: .leading, spacing: 2) {
                Text("\(agent.agentType.rawValue) Agent")
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Text(agent.summary)
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(2)
                
                Text("Completed \(agent.completedDate)")
                    .font(.custom("Futura", size: 11))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
            
            // Tasks completed
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(agent.tasksCompleted)/\(agent.totalTasks)")
                    .font(.custom("Futura", size: 12))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Text("tasks")
                    .font(.custom("Futura", size: 10))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
}

struct CommunicationLogRow: View {
    let log: CommunicationLog
    
    var body: some View {
        HStack(spacing: 8) {
            Text(log.timestamp)
                .font(.custom("Futura", size: 10))
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 50, alignment: .leading)
            
            Image(systemName: log.agentType.icon)
                .font(.system(size: 12))
                .foregroundStyle(log.agentType.color)
                .frame(width: 16)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(log.action)
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white)
                
                Text(log.result)
                    .font(.custom("Futura", size: 11))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct SpendingCategoryRow: View {
    let category: SpendingCategory
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.system(size: 16))
                .foregroundStyle(category.color)
                .frame(width: 20)
            
            Text(category.name)
                .font(.custom("Futura", size: 14))
                .foregroundStyle(.white)
            
            Spacer()
            
            Text("₹\(category.amount)")
                .font(.custom("Futura", size: 14))
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
    }
}

struct AgentSavingRow: View {
    let saving: AgentSaving
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: saving.agentType.icon)
                .font(.system(size: 12))
                .foregroundStyle(saving.agentType.color)
                .frame(width: 16)
            
            Text(saving.description)
                .font(.custom("Futura", size: 12))
                .foregroundStyle(.white.opacity(0.8))
            
            Spacer()
            
            Text("₹\(saving.amountSaved)")
                .font(.custom("Futura", size: 12))
                .fontWeight(.medium)
                .foregroundStyle(.green)
        }
    }
}

// MARK: - Sample Data Extensions
extension TripDetailView {
    var todayTimelineItems: [TimelineItem] {
        [
            TimelineItem(time: "9:00", title: "Hotel breakfast", description: "Hotel Maidens breakfast buffet", status: .completed, notes: "Excellent parathas!"),
            TimelineItem(time: "10:30", title: "Hotel checkout", description: "Checked out from Hotel Maidens", status: .completed, notes: "Left luggage at reception"),
            TimelineItem(time: "11:00", title: "India Gate visit", description: "Photo session at India Gate", status: .completed, notes: "Perfect weather for photos"),
            TimelineItem(time: "12:30", title: "Lunch", description: "Paranthe Wali Gali food tour", status: .completed, notes: "Tried 4 different parathas"),
            TimelineItem(time: "2:00", title: "Prep for Red Fort", description: "Preparing for Red Fort visit", status: .current, notes: "Weather looking perfect!"),
            TimelineItem(time: "2:30", title: "Auto to Red Fort", description: "Pre-booked auto-rickshaw", status: .pending, notes: "Agent suggests leaving now"),
            TimelineItem(time: "3:00", title: "Red Fort exploration", description: "Guided tour with pre-booked tickets", status: .pending, notes: nil),
            TimelineItem(time: "5:30", title: "Chandni Chowk", description: "Street food tour", status: .pending, notes: nil),
            TimelineItem(time: "7:30", title: "Dinner at Karim's", description: "Famous mutton korma", status: .pending, notes: "Reservation confirmed")
        ]
    }
    
    var yesterdayTimelineItems: [TimelineItem] {
        [
            TimelineItem(time: "9:00", title: "Humayun's Tomb", description: "UNESCO World Heritage site visit", status: .completed, notes: "Beautiful Mughal architecture"),
            TimelineItem(time: "12:00", title: "Lunch at Karim's", description: "First visit to famous restaurant", status: .completed, notes: "Amazing biryani"),
            TimelineItem(time: "2:30", title: "Qutub Minar", description: "Tallest brick minaret visit", status: .completed, notes: "Great history lesson"),
            TimelineItem(time: "5:00", title: "Lotus Temple", description: "Peaceful meditation time", status: .completed, notes: "Very serene atmosphere"),
            TimelineItem(time: "7:00", title: "Connaught Place", description: "Shopping and dinner", status: .completed, notes: "Bought souvenirs")
        ]
    }
    
    var day1TimelineItems: [TimelineItem] {
        [
            TimelineItem(time: "10:00", title: "Arrival", description: "Landed at Delhi Airport", status: .completed, notes: "Flight on time"),
            TimelineItem(time: "11:30", title: "Hotel check-in", description: "Hotel Maidens, Civil Lines", status: .completed, notes: "Room upgrade received"),
            TimelineItem(time: "1:00", title: "Lunch", description: "Hotel restaurant", status: .completed, notes: "Local cuisine introduction"),
            TimelineItem(time: "3:00", title: "Rest time", description: "Recovered from travel", status: .completed, notes: nil),
            TimelineItem(time: "5:00", title: "Local market", description: "Explored nearby markets", status: .completed, notes: "Great local experience"),
            TimelineItem(time: "7:30", title: "Welcome dinner", description: "Local restaurant recommendation", status: .completed, notes: "Friendly staff")
        ]
    }
    
    var tomorrowTimelineItems: [TimelineItem] {
        [
            TimelineItem(time: "8:00", title: "Final packing", description: "Pack bags and checkout", status: .pending, notes: nil),
            TimelineItem(time: "9:00", title: "Breakfast", description: "Last breakfast in Delhi", status: .pending, notes: nil),
            TimelineItem(time: "10:00", title: "Airport transfer", description: "Pre-booked taxi to airport", status: .pending, notes: "Agent will track traffic"),
            TimelineItem(time: "12:00", title: "Flight departure", description: "Return journey begins", status: .pending, notes: "Check-in confirmed")
        ]
    }
    
    var activeAgentHistory: [AgentHistory] {
        [
            AgentHistory(
                agentType: .weather,
                completedDate: "Ongoing",
                tasksCompleted: 12,
                totalTasks: 15,
                summary: "Continuously monitoring weather conditions and providing real-time updates"
            ),
            AgentHistory(
                agentType: .traffic,
                completedDate: "Ongoing", 
                tasksCompleted: 8,
                totalTasks: 10,
                summary: "Live traffic monitoring and route optimization for remaining activities"
            )
        ]
    }
    
    var completedAgentHistory: [AgentHistory] {
        [
            AgentHistory(
                agentType: .booking,
                completedDate: "2 days ago",
                tasksCompleted: 6,
                totalTasks: 6,
                summary: "All reservations confirmed: restaurants, tours, transport, and hotel"
            ),
            AgentHistory(
                agentType: .activity,
                completedDate: "2 days ago",
                tasksCompleted: 8,
                totalTasks: 8,
                summary: "All activity tickets secured and optimal timing planned"
            ),
            AgentHistory(
                agentType: .transport,
                completedDate: "1 day ago",
                tasksCompleted: 5,
                totalTasks: 5,
                summary: "All transportation arranged: metro cards, auto bookings, airport transfer"
            ),
            AgentHistory(
                agentType: .hotel,
                completedDate: "3 days ago",
                tasksCompleted: 3,
                totalTasks: 3,
                summary: "Hotel Maidens booked with room upgrade negotiated"
            )
        ]
    }
    
    var communicationLog: [CommunicationLog] {
        [
            CommunicationLog(timestamp: "2:01 PM", agentType: .traffic, action: "Route check", result: "Light traffic to Red Fort"),
            CommunicationLog(timestamp: "1:58 PM", agentType: .weather, action: "Weather update", result: "Clear skies, perfect for photos"),
            CommunicationLog(timestamp: "1:45 PM", agentType: .traffic, action: "Auto booking", result: "Confirmed pickup at 2:30 PM"),
            CommunicationLog(timestamp: "12:30 PM", agentType: .restaurant, action: "Karim's call", result: "Table confirmed for 7:30 PM"),
            CommunicationLog(timestamp: "10:15 AM", agentType: .weather, action: "Day forecast", result: "Sunny day, ideal for sightseeing"),
            CommunicationLog(timestamp: "2 days ago", agentType: .booking, action: "Red Fort tickets", result: "2 tickets secured for today"),
            CommunicationLog(timestamp: "2 days ago", agentType: .transport, action: "Metro cards", result: "2 day passes purchased")
        ]
    }
    
    var spendingCategories: [SpendingCategory] {
        [
            SpendingCategory(name: "Accommodation", amount: 4500, icon: "bed.double.fill", color: .blue),
            SpendingCategory(name: "Food & Dining", amount: 3200, icon: "fork.knife", color: .orange),
            SpendingCategory(name: "Transportation", amount: 2800, icon: "car.fill", color: .green),
            SpendingCategory(name: "Activities & Tours", amount: 1900, icon: "ticket.fill", color: .purple),
            SpendingCategory(name: "Shopping", amount: 800, icon: "bag.fill", color: .pink)
        ]
    }
    
    var agentSavings: [AgentSaving] {
        [
            AgentSaving(agentType: .booking, description: "Group discount at Red Fort", amountSaved: 400),
            AgentSaving(agentType: .transport, description: "Metro day pass vs individual tickets", amountSaved: 280),
            AgentSaving(agentType: .restaurant, description: "Local restaurant vs tourist spot", amountSaved: 600),
            AgentSaving(agentType: .hotel, description: "Room upgrade negotiated for free", amountSaved: 1000),
            AgentSaving(agentType: .activity, description: "Combo ticket deals found", amountSaved: 320)
        ]
    }
}

#Preview {
    NavigationView {
        TripDetailView(trip: UpcomingTrip(
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
            bookings: TripBookings(flights: nil, hotels: [], selectedHotel: nil, transport: [], activities: []),
            notes: "Day 3 of 3 - All planning complete, only monitoring agents active"
        ))
    }
}