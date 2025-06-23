//
//  QuickActionCard.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct QuickActionCard: View {
    let action: QuickAction
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.3
    
    var body: some View {
        Button(action: {
            handleAction()
        }) {
            VStack(spacing: 12) {
                // Icon with glow effect
                ZStack {
                    Circle()
                        .fill(actionColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(actionColor.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: actionColor.opacity(glowIntensity), radius: 8, x: 0, y: 0)
                    
                    Image(systemName: action.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(actionColor)
                }
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        glowIntensity = 0.6
                    }
                }
                
                // Title and subtitle
                VStack(spacing: 4) {
                    Text(action.title)
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Text(action.subtitle)
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                }
                
                // Value display
                if let value = action.value {
                    Text(value)
                        .font(.custom("Futura", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(actionColor)
                }
            }
            .padding(20)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(actionColor.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
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
    
    private var actionColor: Color {
        switch action.action {
        case .weather: return .blue
        case .calendar: return .green
        case .traffic: return .orange
        case .reminders: return .red
        case .notes: return .yellow
        case .contacts: return .purple
        }
    }
    
    private func handleAction() {
        switch action.action {
        case .weather:
            print("Opening weather app")
        case .calendar:
            print("Opening calendar")
        case .traffic:
            print("Checking traffic conditions")
        case .reminders:
            print("Opening reminders")
        case .notes:
            print("Opening notes")
        case .contacts:
            print("Opening contacts")
        }
    }
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
        QuickActionCard(action: QuickAction(
            title: "Weather",
            subtitle: "Partly Cloudy",
            icon: "cloud.sun",
            action: .weather,
            value: "22°C"
        ))
        
        QuickActionCard(action: QuickAction(
            title: "Calendar",
            subtitle: "Events today",
            icon: "calendar",
            action: .calendar,
            value: "3"
        ))
        
        QuickActionCard(action: QuickAction(
            title: "Traffic",
            subtitle: "Current conditions",
            icon: "car.fill",
            action: .traffic,
            value: "Light"
        ))
        
        QuickActionCard(action: QuickAction(
            title: "Reminders",
            subtitle: "Pending tasks",
            icon: "bell.fill",
            action: .reminders,
            value: "2"
        ))
    }
    .padding()
    .background(Color.black)
}