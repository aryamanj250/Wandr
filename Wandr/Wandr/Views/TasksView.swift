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
    
    private var filteredTasks: [ButlerTask] {
        switch selectedFilter {
        case .all:
            return sampleTasks
        case .urgent:
            return sampleTasks.filter { $0.priority == .urgent }
        case .today:
            return sampleTasks.filter { $0.dueTime?.contains("PM") == true || $0.dueTime?.contains("AM") == true }
        case .actionable:
            return sampleTasks.filter { $0.actionable }
        }
    }
    
    private func taskCount(for filter: TaskFilter) -> Int {
        switch filter {
        case .all:
            return sampleTasks.count
        case .urgent:
            return sampleTasks.filter { $0.priority == .urgent }.count
        case .today:
            return sampleTasks.filter { $0.dueTime?.contains("PM") == true || $0.dueTime?.contains("AM") == true }.count
        case .actionable:
            return sampleTasks.filter { $0.actionable }.count
        }
    }
    
    private var sampleTasks: [ButlerTask] {
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
                priority: .urgent,
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
            ),
            ButlerTask(
                title: "Confirm hotel reservation",
                description: "Call Marriott to confirm check-in time",
                priority: .high,
                dueTime: "2:00 PM",
                category: .travel,
                actionable: true,
                icon: "building.2.fill",
                estimatedDuration: "3 min"
            ),
            ButlerTask(
                title: "Buy travel insurance",
                description: "Compare and purchase travel insurance for Tokyo trip",
                priority: .medium,
                dueTime: "This week",
                category: .travel,
                actionable: true,
                icon: "shield.fill",
                estimatedDuration: "20 min"
            )
        ]
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