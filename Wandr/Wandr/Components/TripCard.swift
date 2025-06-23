//
//  TripCard.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct TripCard: View {
    let trip: UpcomingTrip
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Handle trip card tap
            print("Tapped trip to \(trip.destination)")
        }) {
            VStack(spacing: 0) {
                // Trip image/header
                ZStack {
                    // Background gradient based on destination
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 120)
                    
                    // Destination overlay
                    VStack {
                        Spacer()
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(trip.destination)
                                    .font(.custom("Futura", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                
                                Text(formatDepartureDate())
                                    .font(.custom("Futura", size: 12))
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            // Status badge
                            statusBadge
                        }
                        .padding(16)
                    }
                }
                
                // Trip details
                VStack(spacing: 12) {
                    HStack {
                        Label(trip.duration, systemImage: "calendar")
                            .font(.custom("Futura", size: 13))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Spacer()
                        
                        if let budget = trip.budget {
                            Label(budget, systemImage: "dollarsign.circle")
                                .font(.custom("Futura", size: 13))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    
                    HStack {
                        Label("\(trip.participants.count) people", systemImage: "person.2.fill")
                            .font(.custom("Futura", size: 13))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("View Details")
                            .font(.custom("Futura", size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.1))
                                    .overlay(
                                        Capsule()
                                            .stroke(.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                }
                .padding(18)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 280)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.1), lineWidth: 1)
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
    
    private var statusBadge: some View {
        Text(trip.status.displayName)
            .font(.custom("Futura", size: 11))
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(statusColor.opacity(0.8))
                    .overlay(
                        Capsule()
                            .stroke(statusColor.opacity(0.3), lineWidth: 1)
                    )
            )
    }
    
    private var statusColor: Color {
        switch trip.status {
        case .planning: return .orange
        case .booked: return .blue
        case .confirmed: return .green
        case .inProgress: return .purple
        }
    }
    
    private var gradientColors: [Color] {
        // Different gradients based on destination
        let destination = trip.destination.lowercased()
        
        if destination.contains("tokyo") || destination.contains("japan") {
            return [.pink.opacity(0.8), .red.opacity(0.6)]
        } else if destination.contains("paris") || destination.contains("france") {
            return [.blue.opacity(0.8), .purple.opacity(0.6)]
        } else if destination.contains("bali") || destination.contains("indonesia") {
            return [.green.opacity(0.8), .teal.opacity(0.6)]
        } else if destination.contains("new york") || destination.contains("usa") {
            return [.yellow.opacity(0.8), .orange.opacity(0.6)]
        } else {
            return [.indigo.opacity(0.8), .blue.opacity(0.6)]
        }
    }
    
    private func formatDepartureDate() -> String {
        let formatter = DateFormatter()
        
        let calendar = Calendar.current
        let now = Date()
        let daysDifference = calendar.dateComponents([.day], from: now, to: trip.departureDate).day ?? 0
        
        if daysDifference == 0 {
            return "Departing today"
        } else if daysDifference == 1 {
            return "Departing tomorrow"
        } else if daysDifference < 7 {
            return "Departing in \(daysDifference) days"
        } else {
            formatter.dateStyle = .medium
            return "Departing " + formatter.string(from: trip.departureDate)
        }
    }
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15) {
            TripCard(trip: UpcomingTrip(
                destination: "Tokyo, Japan",
                departureDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                returnDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
                duration: "7 days",
                status: .confirmed,
                imageUrl: nil,
                budget: "$2,500",
                companions: 1,
                participants: ["You", "Emma"],
                progress: TripProgress(totalSteps: 5, completedSteps: 5, currentAction: nil, nextAction: nil, estimatedCompletion: nil),
                bookings: TripBookings(flights: nil, hotels: [], selectedHotel: nil, transport: [], activities: []),
                notes: nil
            ))
        }
        .padding()
    }
    .background(Color.black)
}