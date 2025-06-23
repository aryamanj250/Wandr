//
//  TaskCard.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct TaskCard: View {
    let task: ButlerTask
    @State private var isPressed = false
    @State private var showActionMenu = false
    
    var body: some View {
        Button(action: {
            if task.actionable {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showActionMenu.toggle()
                }
            }
        }) {
            VStack(spacing: 0) {
                // Main task content
                HStack(spacing: 15) {
                    // Priority indicator & icon
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(priorityColor.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: task.icon)
                                .font(.system(size: 18))
                                .foregroundStyle(priorityColor)
                        }
                        
                        if let duration = task.estimatedDuration {
                            Text(duration)
                                .font(.custom("Futura", size: 10))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                    
                    // Task details
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(task.title)
                                .font(.custom("Futura", size: 16))
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            if let dueTime = task.dueTime {
                                Text(dueTime)
                                    .font(.custom("Futura", size: 12))
                                    .foregroundStyle(.white.opacity(0.6))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(
                                        Capsule()
                                            .fill(.white.opacity(0.1))
                                    )
                            }
                        }
                        
                        Text(task.description)
                            .font(.custom("Futura", size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        // Priority and category tags
                        HStack(spacing: 8) {
                            Label(task.priority.rawValue.capitalized, systemImage: "exclamationmark.circle.fill")
                                .font(.custom("Futura", size: 11))
                                .foregroundStyle(priorityColor)
                            
                            Label(task.category.rawValue.capitalized, systemImage: task.category.icon)
                                .font(.custom("Futura", size: 11))
                                .foregroundStyle(.white.opacity(0.5))
                            
                            Spacer()
                            
                            if task.actionable {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white.opacity(0.4))
                            }
                        }
                    }
                }
                .padding(18)
                
                // Action buttons (when expanded)
                if showActionMenu && task.actionable {
                    VStack(spacing: 0) {
                        Divider()
                            .background(.white.opacity(0.1))
                        
                        HStack(spacing: 12) {
                            ForEach(taskActions, id: \.title) { action in
                                Button(action: {
                                    handleAction(action)
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: action.icon)
                                            .font(.system(size: 14))
                                        Text(action.title)
                                            .font(.custom("Futura", size: 13))
                                            .fontWeight(.medium)
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.white.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                            
                            Spacer()
                        }
                        .padding(18)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(priorityColor.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
    
    private var priorityColor: Color {
        switch task.priority {
        case .urgent: return .red
        case .high: return .orange
        case .medium: return .yellow
        case .low: return .green
        }
    }
    
    private var taskActions: [TaskAction] {
        switch task.category {
        case .transport:
            return [
                TaskAction(title: "Book Now", icon: "car.fill", actionType: .book),
                TaskAction(title: "Call", icon: "phone.fill", actionType: .call),
                TaskAction(title: "Delay", icon: "clock.fill", actionType: .delay)
            ]
        case .dining:
            return [
                TaskAction(title: "Call Restaurant", icon: "phone.fill", actionType: .call),
                TaskAction(title: "Directions", icon: "location.fill", actionType: .navigate),
                TaskAction(title: "Menu", icon: "list.bullet", actionType: .view)
            ]
        case .travel:
            return [
                TaskAction(title: "Check In", icon: "airplane", actionType: .checkin),
                TaskAction(title: "Details", icon: "info.circle", actionType: .view),
                TaskAction(title: "Remind Later", icon: "bell.fill", actionType: .remind)
            ]
        default:
            return [
                TaskAction(title: "Mark Done", icon: "checkmark.circle.fill", actionType: .complete),
                TaskAction(title: "Remind Later", icon: "bell.fill", actionType: .remind)
            ]
        }
    }
    
    private func handleAction(_ action: TaskAction) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showActionMenu = false
        }
        
        // Handle different action types
        switch action.actionType {
        case .book:
            print("Booking \(task.title)")
        case .call:
            print("Calling for \(task.title)")
        case .navigate:
            print("Getting directions for \(task.title)")
        case .complete:
            print("Marking \(task.title) as complete")
        case .remind:
            print("Setting reminder for \(task.title)")
        case .delay:
            print("Delaying \(task.title)")
        case .checkin:
            print("Checking in for \(task.title)")
        case .view:
            print("Viewing details for \(task.title)")
        }
    }
}

struct TaskAction {
    let title: String
    let icon: String
    let actionType: TaskActionType
}

enum TaskActionType {
    case book, call, navigate, complete, remind, delay, checkin, view
}

#Preview {
    VStack(spacing: 20) {
        TaskCard(task: ButlerTask(
            title: "Get taxi to restaurant",
            description: "Book ride to La Bernardin for 8:00 PM reservation",
            priority: .high,
            dueTime: "7:30 PM",
            category: .transport,
            actionable: true,
            icon: "car.fill",
            estimatedDuration: "5 min"
        ))
        
        TaskCard(task: ButlerTask(
            title: "Pack essentials",
            description: "Don't forget charger and travel documents for tomorrow's trip",
            priority: .medium,
            dueTime: "Tonight",
            category: .reminder,
            actionable: false,
            icon: "suitcase.fill",
            estimatedDuration: "15 min"
        ))
    }
    .padding()
    .background(Color.black)
}