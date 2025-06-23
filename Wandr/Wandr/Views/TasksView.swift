//
//  TasksView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct TasksView: View {
    @State private var selectedFilter: TaskFilter = .all
    @State private var showAddTask = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                ButlerBackground()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Filter tabs
                    filterTabs
                    
                    // Agent Tasks list
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            // Current trip agent tasks
                            if !currentTripAgentTasks.isEmpty {
                                agentTaskSection(title: "Delhi Trip - Active Agents", tasks: currentTripAgentTasks, color: .green)
                            }
                            
                            // Upcoming trip agent tasks
                            if !upcomingTripAgentTasks.isEmpty {
                                agentTaskSection(title: "Goa Trip - Planning Agents", tasks: upcomingTripAgentTasks, color: .orange)
                            }
                            
                            // Completed agent tasks
                            if !completedAgentTasks.isEmpty {
                                agentTaskSection(title: "Recently Completed", tasks: completedAgentTasks, color: .blue)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddTask = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView()
        }
    }
    
    private var filterTabs: some View {
        HStack(spacing: 0) {
            ForEach(TaskFilter.allCases, id: \.self) { filter in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedFilter = filter
                    }
                }) {
                    VStack(spacing: 4) {
                        Text(filter.title)
                            .font(.custom("Futura", size: 14))
                            .fontWeight(.medium)
                        
                        Text("\(taskCount(for: filter))")
                            .font(.custom("Futura", size: 12))
                            .opacity(0.7)
                    }
                    .foregroundStyle(selectedFilter == filter ? .white : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        selectedFilter == filter ?
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
    
    // Agent task data sources
    private var currentTripAgentTasks: [AgentActivity] {
        [
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
            )
        ]
    }
    
    private var upcomingTripAgentTasks: [AgentActivity] {
        [
            AgentActivity(
                agentType: .booking,
                status: .active,
                currentTask: "Researching best beach resorts in Goa under ₹5k budget",
                lastUpdate: "2 minutes ago",
                progress: 0.3
            ),
            AgentActivity(
                agentType: .activity,
                status: .active,
                currentTask: "Finding offbeat places and beer spots in Goa",
                lastUpdate: "3 minutes ago",
                progress: 0.6
            ),
            AgentActivity(
                agentType: .transport,
                status: .waiting,
                currentTask: "Monitoring flight prices for Goa departure",
                lastUpdate: "5 minutes ago",
                progress: 0.1
            )
        ]
    }
    
    private var completedAgentTasks: [AgentActivity] {
        [
            AgentActivity(
                agentType: .booking,
                status: .completed,
                currentTask: "All Delhi trip reservations confirmed (Karim's, Red Fort, transport)",
                lastUpdate: "2 days ago",
                progress: 1.0
            ),
            AgentActivity(
                agentType: .activity,
                status: .completed,
                currentTask: "All Delhi activity tickets secured and timing optimized",
                lastUpdate: "2 days ago",
                progress: 1.0
            ),
            AgentActivity(
                agentType: .hotel,
                status: .completed,
                currentTask: "Hotel Maidens booked with room upgrade negotiated",
                lastUpdate: "3 days ago",
                progress: 1.0
            )
        ]
    }
    
    private func taskCount(for filter: TaskFilter) -> Int {
        let allTasks = currentTripAgentTasks + upcomingTripAgentTasks + completedAgentTasks
        
        switch filter {
        case .all:
            return allTasks.count
        case .urgent:
            return allTasks.filter { $0.status == .active && $0.agentType == .weather || $0.agentType == .traffic }.count
        case .today:
            return currentTripAgentTasks.count
        case .actionable:
            return allTasks.filter { $0.status == .active }.count
        }
    }
    
    // Agent task section builder
    private func agentTaskSection(title: String, tasks: [AgentActivity], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(tasks.count) agents")
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                ForEach(tasks) { task in
                    AgentTaskRow(task: task)
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
}

// Agent Task Row
struct AgentTaskRow: View {
    let task: AgentActivity
    
    var body: some View {
        HStack(spacing: 12) {
            // Agent type icon
            ZStack {
                Circle()
                    .fill(task.agentType.color.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Image(systemName: task.agentType.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(task.agentType.color)
            }
            
            // Task details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(task.agentType.rawValue) Agent")
                        .font(.custom("Futura", size: 14))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    // Status badge
                    HStack(spacing: 4) {
                        Circle()
                            .fill(task.status.color)
                            .frame(width: 6, height: 6)
                        
                        Text(task.status.rawValue)
                            .font(.custom("Futura", size: 10))
                            .foregroundStyle(task.status.color)
                            .fontWeight(.medium)
                    }
                }
                
                Text(task.currentTask)
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(2)
                
                HStack {
                    Text(task.lastUpdate)
                        .font(.custom("Futura", size: 11))
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Spacer()
                    
                    if task.status == .active {
                        ProgressView(value: task.progress)
                            .tint(task.agentType.color)
                            .frame(width: 60)
                            .scaleEffect(y: 0.8)
                    }
                }
            }
        }
    }
}

enum TaskFilter: String, CaseIterable {
    case all = "All"
    case urgent = "Urgent"
    case today = "Today"
    case actionable = "Actionable"
    
    var title: String {
        return self.rawValue
    }
}

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                ButlerBackground()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Add New Task")
                        .font(.custom("Futura", size: 24))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text("This feature will be implemented soon")
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    TasksView()
}