//
//  AgentDeploymentView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct AgentDeploymentView: View {
    let preferences: TravelPreferences
    let onComplete: (UpcomingTrip) -> Void
    
    @State private var deployedAgents: [DeployedAgent] = []
    @State private var currentPhase: DeploymentPhase = .initializing
    @State private var overallProgress: Double = 0.0
    @State private var showResults = false
    @State private var generatedTrip: UpcomingTrip?
    
    var body: some View {
        ZStack {
            // Background
            ButlerBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                if !showResults {
                    // Deployment in progress
                    deploymentProgressView
                } else {
                    // Results ready
                    resultsView
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 40)
        }
        .onAppear {
            startAgentDeployment()
        }
    }
    
    private var deploymentProgressView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Text("Deploying AI Agents")
                    .font(.custom("Futura", size: 28))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("Planning your \(preferences.destination) trip")
                    .font(.custom("Futura", size: 16))
                    .foregroundStyle(.white.opacity(0.7))
                
                // Overall progress
                VStack(spacing: 8) {
                    HStack {
                        Text("Overall Progress")
                            .font(.custom("Futura", size: 14))
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text("\(Int(overallProgress * 100))%")
                            .font(.custom("Futura", size: 14))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    
                    ProgressView(value: overallProgress)
                        .tint(.blue)
                        .scaleEffect(y: 2)
                        .background(.white.opacity(0.1))
                }
            }
            
            // Current phase indicator
            phaseIndicator
            
            // Agent activities
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(deployedAgents) { agent in
                        DeployedAgentCard(agent: agent)
                    }
                }
            }
            
            Spacer()
        }
    }
    
    private var phaseIndicator: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(.green)
                .frame(width: 8, height: 8)
                .overlay(
                    Circle()
                        .stroke(.green.opacity(0.3), lineWidth: 2)
                        .scaleEffect(1.5)
                )
            
            Text(currentPhase.description)
                .font(.custom("Futura", size: 14))
                .fontWeight(.medium)
                .foregroundStyle(.green)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.green.opacity(0.1))
                .overlay(
                    Capsule()
                        .stroke(.green.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var resultsView: some View {
        VStack(spacing: 24) {
            // Success header
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(.green.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.green)
                }
                
                Text("Trip Plan Ready!")
                    .font(.custom("Futura", size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("Your \(preferences.destination) trip has been planned with \(deployedAgents.count) agents working together")
                    .font(.custom("Futura", size: 16))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            // Agent completion summary
            VStack(spacing: 12) {
                Text("Agent Summary")
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                LazyVStack(spacing: 8) {
                    ForEach(deployedAgents.filter { $0.status == .completed }) { agent in
                        AgentCompletionRow(agent: agent)
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
            
            // Action buttons
            VStack(spacing: 12) {
                Button(action: {
                    if let trip = generatedTrip {
                        onComplete(trip)
                    }
                }) {
                    HStack {
                        Text("View Trip Details")
                            .font(.custom("Futura", size: 16))
                            .fontWeight(.medium)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
                
                Button(action: {
                    // Continue with planning
                }) {
                    Text("Let Agents Continue Working")
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
            
            Spacer()
        }
    }
    
    private func startAgentDeployment() {
        // Initialize agents based on preferences
        let agentTypes: [AgentType] = [.flight, .hotel, .restaurant, .weather, .activity, .transport]
        
        deployedAgents = agentTypes.map { type in
            DeployedAgent(
                agentType: type,
                status: .initializing,
                tasks: generateTasksForAgent(type),
                completedTasks: 0,
                currentActivity: "Initializing...",
                estimatedTime: "30s"
            )
        }
        
        // Start deployment sequence
        deployAgentsSequentially()
    }
    
    private func deployAgentsSequentially() {
        currentPhase = .deploying
        
        for (index, _) in deployedAgents.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    deployedAgents[index].status = .deployed
                    deployedAgents[index].currentActivity = deployedAgents[index].tasks.first ?? "Starting..."
                }
                
                // Start working after deployment
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    startAgentWork(at: index)
                }
            }
        }
        
        // Update overall progress
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            updateOverallProgress()
            
            if overallProgress >= 1.0 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    completeDeployment()
                }
            }
        }
    }
    
    private func startAgentWork(at index: Int) {
        let agent = deployedAgents[index]
        let totalTasks = agent.tasks.count
        
        withAnimation(.easeInOut(duration: 0.5)) {
            deployedAgents[index].status = .working
        }
        
        // Simulate task completion
        for taskIndex in 0..<totalTasks {
            let delay = Double(taskIndex + 1) * Double.random(in: 1.0...3.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    deployedAgents[index].completedTasks = taskIndex + 1
                    
                    if taskIndex < totalTasks - 1 {
                        deployedAgents[index].currentActivity = agent.tasks[taskIndex + 1]
                    } else {
                        deployedAgents[index].status = .completed
                        deployedAgents[index].currentActivity = "Tasks completed successfully"
                    }
                }
            }
        }
    }
    
    private func updateOverallProgress() {
        let totalTasks = deployedAgents.reduce(0) { $0 + $1.tasks.count }
        let completedTasks = deployedAgents.reduce(0) { $0 + $1.completedTasks }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            overallProgress = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0.0
        }
        
        // Update phase based on progress
        if overallProgress < 0.3 {
            currentPhase = .deploying
        } else if overallProgress < 0.7 {
            currentPhase = .researching
        } else if overallProgress < 0.9 {
            currentPhase = .booking
        } else {
            currentPhase = .finalizing
        }
    }
    
    private func completeDeployment() {
        currentPhase = .completed
        
        // Generate the trip result
        generatedTrip = UpcomingTrip(
            destination: preferences.destination,
            departureDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            returnDate: Calendar.current.date(byAdding: .day, value: 7 + preferences.duration, to: Date()) ?? Date(),
            duration: "\(preferences.duration) days",
            status: .planning,
            imageUrl: nil,
            budget: preferences.budget.displayName,
            companions: preferences.companions,
            participants: generateParticipantNames(count: preferences.companions),
            progress: TripProgress(
                totalSteps: 8,
                completedSteps: 6,
                currentAction: "Agents finalizing bookings",
                nextAction: "User review and approval",
                estimatedCompletion: "Ready for review"
            ),
            bookings: TripBookings(flights: nil, hotels: [], selectedHotel: nil, transport: [], activities: []),
            notes: "Planned by AI agents based on your preferences"
        )
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showResults = true
        }
    }
    
    private func generateTasksForAgent(_ agentType: AgentType) -> [String] {
        switch agentType {
        case .flight:
            return [
                "Searching flight options",
                "Comparing prices across airlines",
                "Checking seat availability",
                "Securing best deals"
            ]
        case .hotel:
            return [
                "Researching accommodations",
                "Checking availability",
                "Calling hotels for group rates",
                "Comparing amenities"
            ]
        case .restaurant:
            return [
                "Finding local restaurants",
                "Checking dietary requirements",
                "Making reservations",
                "Confirming bookings"
            ]
        case .weather:
            return [
                "Fetching weather forecasts",
                "Analyzing climate patterns",
                "Suggesting optimal activities"
            ]
        case .activity:
            return [
                "Discovering local attractions",
                "Booking activity tickets",
                "Checking group availability",
                "Creating activity timeline"
            ]
        case .transport:
            return [
                "Arranging airport transfers",
                "Researching local transport",
                "Booking taxi services"
            ]
        default:
            return ["Processing...", "Analyzing...", "Completing..."]
        }
    }
    
    private func generateParticipantNames(count: Int) -> [String] {
        let names = ["You", "Sarah", "Mike", "Priya", "Alex", "Emma", "Rahul", "Lisa"]
        return Array(names.prefix(count))
    }
}

// MARK: - Supporting Models and Views

struct DeployedAgent: Identifiable {
    let id = UUID()
    let agentType: AgentType
    var status: AgentDeploymentStatus
    let tasks: [String]
    var completedTasks: Int
    var currentActivity: String
    var estimatedTime: String
}

enum AgentDeploymentStatus {
    case initializing
    case deployed
    case working
    case completed
    case error
    
    var color: Color {
        switch self {
        case .initializing: return .gray
        case .deployed: return .blue
        case .working: return .green
        case .completed: return .cyan
        case .error: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .initializing: return "clock"
        case .deployed: return "checkmark.circle"
        case .working: return "gearshape.2"
        case .completed: return "checkmark.circle.fill"
        case .error: return "exclamationmark.triangle"
        }
    }
}

enum DeploymentPhase {
    case initializing
    case deploying
    case researching
    case booking
    case finalizing
    case completed
    
    var description: String {
        switch self {
        case .initializing: return "Initializing AI agents..."
        case .deploying: return "Deploying agents to work..."
        case .researching: return "Agents researching options..."
        case .booking: return "Agents making reservations..."
        case .finalizing: return "Finalizing trip details..."
        case .completed: return "All agents completed successfully!"
        }
    }
}

struct DeployedAgentCard: View {
    let agent: DeployedAgent
    
    var body: some View {
        HStack(spacing: 16) {
            // Agent type icon
            ZStack {
                Circle()
                    .fill(agent.agentType.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: agent.agentType.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(agent.agentType.color)
            }
            
            // Agent details
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(agent.agentType.rawValue) Agent")
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    // Status indicator
                    HStack(spacing: 4) {
                        Image(systemName: agent.status.icon)
                            .font(.system(size: 12))
                            .foregroundStyle(agent.status.color)
                        
                        Text(agent.status == .working ? "Working" : 
                             agent.status == .completed ? "Done" : 
                             agent.status == .deployed ? "Active" : "Starting")
                            .font(.custom("Futura", size: 10))
                            .foregroundStyle(agent.status.color)
                    }
                }
                
                Text(agent.currentActivity)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(2)
                
                // Progress bar
                HStack {
                    ProgressView(value: Double(agent.completedTasks), total: Double(agent.tasks.count))
                        .tint(agent.agentType.color)
                        .scaleEffect(y: 1.5)
                    
                    Text("\(agent.completedTasks)/\(agent.tasks.count)")
                        .font(.custom("Futura", size: 11))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(agent.status.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct AgentCompletionRow: View {
    let agent: DeployedAgent
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: agent.agentType.icon)
                .font(.system(size: 16))
                .foregroundStyle(agent.agentType.color)
            
            Text("\(agent.agentType.rawValue) Agent")
                .font(.custom("Futura", size: 14))
                .foregroundStyle(.white)
            
            Spacer()
            
            Text("\(agent.completedTasks) tasks done")
                .font(.custom("Futura", size: 12))
                .foregroundStyle(.white.opacity(0.6))
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundStyle(.green)
        }
    }
}

#Preview {
    AgentDeploymentView(
        preferences: TravelPreferences(
            destination: "Goa, India",
            duration: 4,
            budget: .moderate,
            accommodationType: .boutique,
            activityPreferences: [.relaxation, .food],
            dietaryRestrictions: [],
            transportPreference: .flight,
            companions: 4
        )
    ) { trip in
        print("Trip created: \(trip)")
    }
}