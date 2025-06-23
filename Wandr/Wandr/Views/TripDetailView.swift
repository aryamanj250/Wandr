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
    @State private var scrollOffset: CGFloat = 0
    @State private var isHeaderCollapsed: Bool = false
    @State private var selectedTimelineItem: TimelineItem? = nil
    
    var body: some View {
        ZStack {
            // Background
            ButlerBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Tab selector (fixed)
                tabSelector
                
                // Scrollable content with collapsible header
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            // Collapsible header
                            collapsibleTripHeader
                            
                            // Overview section when header is collapsed
                            if isHeaderCollapsed {
                                overviewSection
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            
                            // Content
                            VStack(spacing: 20) {
                                switch selectedTab {
                                case .timeline:
                                    nativeTimelineContent
                                case .agents:
                                    nativeAgentContent
                                case .budget:
                                    nativeBudgetContent
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                            }
                        )
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isHeaderCollapsed = value < -50
                        }
                    }
                }
            }
        }
        .navigationTitle(trip.destination)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundStyle(.white)
            }
        }
    }
    
    // MARK: - Collapsible Header
    private var collapsibleTripHeader: some View {
        VStack(spacing: 16) {
            // Trip title and status
            VStack(spacing: 8) {
                Text(trip.destination)
                    .font(.custom("Futura", size: isHeaderCollapsed ? 18 : 24))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .animation(.easeInOut(duration: 0.3), value: isHeaderCollapsed)
                
                if !isHeaderCollapsed {
                    HStack(spacing: 16) {
                        Label("Day 3 of 3", systemImage: "calendar")
                            .font(.custom("Futura", size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Label("\\(trip.companions) people", systemImage: "person.3.fill")
                            .font(.custom("Futura", size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Label(trip.budget ?? "Budget not set", systemImage: "creditcard")
                            .font(.custom("Futura", size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            
            // Progress bar (compact when collapsed)
            VStack(spacing: isHeaderCollapsed ? 4 : 12) {
                if !isHeaderCollapsed {
                    HStack {
                        Text("Overall Progress")
                            .font(.custom("Futura", size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text("\\(Int(trip.progress.progressPercentage * 100))% Complete")
                            .font(.custom("Futura", size: 14))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                ProgressView(value: trip.progress.progressPercentage)
                    .tint(.blue)
                    .scaleEffect(y: isHeaderCollapsed ? 1 : 2)
                    .background(.white.opacity(0.1))
                    .animation(.easeInOut(duration: 0.3), value: isHeaderCollapsed)
            }
            
            // Live status (hide when collapsed)
            if !isHeaderCollapsed {
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
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .padding(isHeaderCollapsed ? 12 : 20)
        .background(
            RoundedRectangle(cornerRadius: isHeaderCollapsed ? 12 : 20)
                .fill(.white.opacity(isHeaderCollapsed ? 0.03 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: isHeaderCollapsed ? 12 : 20)
                        .stroke(.blue.opacity(0.3), lineWidth: 1)
                )
                .animation(.easeInOut(duration: 0.3), value: isHeaderCollapsed)
        )
        .padding(.horizontal, isHeaderCollapsed ? 10 : 20)
        .animation(.easeInOut(duration: 0.3), value: isHeaderCollapsed)
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Overview")
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button("Go to Timeline") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = .timeline
                    }
                }
                .font(.custom("Futura", size: 14))
                .foregroundStyle(.blue)
            }
            
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    Label("Day 3 of 3", systemImage: "calendar")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Label("\\(trip.companions) people", systemImage: "person.3.fill")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                    
                    Text("2 monitoring agents active")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.green)
                    
                    Spacer()
                    
                    Text("\\(Int(trip.progress.progressPercentage * 100))% Complete")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Native Content Views
    private var nativeTimelineContent: some View {
        NativeTimelineView(trip: trip)
    }
    
    private var nativeAgentContent: some View {
        List {
            Section("Currently Active") {
                ForEach(activeAgentHistory) { agent in
                    NativeAgentRow(agent: agent)
                }
            }
            
            Section("Completed Work") {
                ForEach(completedAgentHistory) { agent in
                    NativeAgentRow(agent: agent)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
    }
    
    private var nativeBudgetContent: some View {
        List {
            Section("Budget Overview") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Budget")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("₹15,000")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Spent")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("₹13,200")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section("Spending") {
                ForEach(spendingCategories) { category in
                    HStack {
                        Image(systemName: category.icon)
                            .foregroundStyle(category.color)
                            .frame(width: 20)
                        
                        Text(category.name)
                        
                        Spacer()
                        
                        Text("₹\\(category.amount)")
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(TripDetailTab.allCases, id: \\.self) { tab in
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
}

// MARK: - Sample Data Extensions
extension TripDetailView {
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
    
    var spendingCategories: [SpendingCategory] {
        [
            SpendingCategory(name: "Accommodation", amount: 4500, icon: "bed.double.fill", color: .blue),
            SpendingCategory(name: "Food & Dining", amount: 3200, icon: "fork.knife", color: .orange),
            SpendingCategory(name: "Transportation", amount: 2800, icon: "car.fill", color: .green),
            SpendingCategory(name: "Activities & Tours", amount: 1900, icon: "ticket.fill", color: .purple),
            SpendingCategory(name: "Shopping", amount: 800, icon: "bag.fill", color: .pink)
        ]
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

struct SpendingCategory: Identifiable {
    let id = UUID()
    let name: String
    let amount: Int
    let icon: String
    let color: Color
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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