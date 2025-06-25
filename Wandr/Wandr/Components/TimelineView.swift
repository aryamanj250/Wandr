//
//  TimelineView.swift
//  Wandr
//
//  Created by Aryaman Jaiswal on 23/06/25.
//

import SwiftUI

struct TimelineView: View {
    let items: [ItineraryItem]
    @State private var animationProgress: CGFloat = 0
    @State private var showItems = false
    @State private var lineProgress: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                let delay = Double(index) * 0.15
                
                TimelineItemView(
                    item: item,
                    isLast: index == items.count - 1,
                    lineProgress: index == 0 ? lineProgress : (showItems ? 1.0 : 0.0),
                    delay: delay
                )
                .opacity(showItems ? 1 : 0)
                .offset(y: showItems ? 0 : 30)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay), value: showItems)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 1.5)) {
                    animationProgress = 1.0
                }
                
                showItems = true
                
                withAnimation(.easeInOut(duration: 1.2).delay(0.5)) {
                    lineProgress = 1.0
                }
            }
        }
    }
}

struct TimelineItemView: View {
    let item: ItineraryItem
    let isLast: Bool
    var lineProgress: CGFloat = 1.0
    var delay: Double = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Time column with timeline
            VStack(spacing: 0) {
                // Time label
                Text(item.time)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.bottom, 8)
                    .frame(width: 80)
                
                // Timeline dot
                ZStack {
                    // Dot wrapper
                    Circle()
                        .stroke(Color.white.opacity(0.6), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    // Center dot
                    Circle()
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                }
                
                // Timeline line with growing animation
                if !isLast {
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 2, height: geometry.size.height * lineProgress)
                            .frame(height: geometry.size.height, alignment: .top)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(height: 70)
                    .frame(width: 80)
                }
            }
            .frame(width: 80)
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                // Title with icon
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: icon(for: item.type))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.05))
                        )
                    
                    Text(item.name)
                        .font(.custom("Futura", size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                
                // Why Recommended
                Text(item.whyRecommended)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Description
                Text(item.description)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.8))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Price Range / Budget Impact
                HStack {
                    if let priceRange = item.priceRange, !priceRange.isEmpty {
                        Text(priceRange)
                            .font(.custom("Futura", size: 14))
                            .fontWeight(.medium)
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    } else {
                        Text("$\(item.budgetImpact, specifier: "%.0f")")
                            .font(.custom("Futura", size: 14))
                            .fontWeight(.medium)
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                    
                    if let rating = item.rating {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.yellow)
                            Text(String(format: "%.1f", rating))
                                .font(.custom("Futura", size: 14))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                    }
                }
                
                if item.bookingRequired {
                    Text("Booking Recommended")
                        .font(.custom("Futura", size: 12))
                        .fontWeight(.medium)
                        .foregroundStyle(.orange)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.orange.opacity(0.1))
                        )
                }
                
                if let currentStatus = item.currentStatus, !currentStatus.isEmpty {
                    Text("Status: \(currentStatus)")
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                if let notes = item.notes, !notes.isEmpty {
                    Text("Notes: \(notes)")
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, isLast ? 10 : 25)
    }
    
    private func icon(for type: String) -> String {
        switch type.lowercased() {
        case "food", "restaurant", "cafe":
            return "fork.knife"
        case "experience", "activity":
            return "figure.walk"
        case "sightseeing", "landmark":
            return "eye.fill"
        case "travel", "transport":
            return "car.fill"
        case "beach":
            return "beach.umbrella.fill"
        case "party", "nightlife":
            return "music.mic"
        default:
            return "mappin.and.ellipse"
        }
    }
}

// Preview
#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        TimelineView(items: [
            ItineraryItem(
                id: UUID().uuidString,
                day: 1,
                name: "Anjuna Beach Sunrise",
                type: "sightseeing",
                location: "Anjuna Beach, Goa",
                description: "Start your day with a serene sunrise at Anjuna Beach, perfect for quiet contemplation.",
                time: "6:00 AM",
                rating: 4.5,
                priceRange: "Free",
                budgetImpact: 0,
                whyRecommended: "Iconic spot for tranquility and beautiful views.",
                currentStatus: "Open",
                bookingRequired: false,
                notes: nil
            ),
            ItineraryItem(
                id: UUID().uuidString,
                day: 1,
                name: "Breakfast at German Bakery",
                type: "food",
                location: "Anjuna, Goa",
                description: "Enjoy a healthy and delicious breakfast at the famous German Bakery.",
                time: "9:00 AM",
                rating: 4.0,
                priceRange: "₹300-500 per person",
                budgetImpact: 400,
                whyRecommended: "Popular for its fresh bakes and relaxed ambiance.",
                currentStatus: "Open",
                bookingRequired: false,
                notes: "Try their apple crumble."
            ),
            ItineraryItem(
                id: UUID().uuidString,
                day: 1,
                name: "Explore Anjuna Flea Market",
                type: "experience",
                location: "Anjuna, Goa",
                description: "Discover unique souvenirs, clothes, and handicrafts at this vibrant market.",
                time: "11:00 AM",
                rating: 3.8,
                priceRange: "Varies",
                budgetImpact: 800,
                whyRecommended: "A cultural experience with diverse offerings.",
                currentStatus: "Open on Wednesdays",
                bookingRequired: false,
                notes: "Bargaining is key!"
            )
        ])
        .padding()
    }
}
