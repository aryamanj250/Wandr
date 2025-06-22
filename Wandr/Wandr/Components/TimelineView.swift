//
//  TimelineView.swift
//  Wandr
//
//  Created by Aryaman Jaiswal on 23/06/25.
//

import SwiftUI
// Models are imported automatically as they're in the same module

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
                    Image(systemName: item.image)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.05))
                        )
                    
                    Text(item.title)
                        .font(.custom("Futura", size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                
                // Description
                Text(item.description)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.8))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Cost badge
                Text(item.cost)
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
}

// Transport Option View with clean styling
struct TransportOptionView: View {
    let option: TransportOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                // Icon
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 38, height: 38)
                    .overlay(
                        Image(systemName: transportIcon)
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    )
                
                Text(option.type)
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            
            Text(option.description)
                .font(.custom("Futura", size: 14))
                .foregroundStyle(.white.opacity(0.8))
                .lineSpacing(4)
                .padding(.leading, 4)
            
            Text(option.cost)
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
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // Get appropriate transport icon
    private var transportIcon: String {
        switch option.type.lowercased() {
        case let type where type.contains("scooter"):
            return "scooter"
        case let type where type.contains("taxi") || type.contains("car"):
            return "car.fill"
        case let type where type.contains("bus"):
            return "bus"
        default:
            return "figure.walk"
        }
    }
}

// Preview
#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        TimelineView(items: [
            ItineraryItem(
                time: "9:00 AM",
                title: "Anjuna Beach",
                description: "Start your day with the sunrise at this beautiful beach.",
                cost: "Free",
                image: "sunrise.fill"
            ),
            ItineraryItem(
                time: "12:00 PM",
                title: "Lunch at Curlies Beach Shack",
                description: "Enjoy budget-friendly seafood and beer with ocean views.",
                cost: "₹600 per person",
                image: "fork.knife"
            ),
            ItineraryItem(
                time: "5:00 PM",
                title: "Sunset at Thalassa",
                description: "Enjoy the famous sunset with a beer in hand at this Greek-themed restaurant.",
                cost: "₹300-400 per person for drinks",
                image: "sunset.fill"
            )
        ])
        .padding()
    }
} 