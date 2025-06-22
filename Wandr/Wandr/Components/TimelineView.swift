//
//  TimelineView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI
// Models are imported automatically as they're in the same module

struct TimelineView: View {
    let items: [ItineraryItem]
    @State private var animationProgress: CGFloat = 0
    @State private var showItems = false
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                let delay = Double(index) * 0.15
                
                TimelineItemView(item: item, isLast: index == items.count - 1)
                    .opacity(showItems ? 1 : 0)
                    .offset(y: showItems ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay), value: showItems)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 1.5)) {
                    animationProgress = 1.0
                }
                
                showItems = true
            }
        }
    }
}

struct TimelineItemView: View {
    let item: ItineraryItem
    let isLast: Bool
    
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
                    Circle()
                        .fill(Color.white)
                        .frame(width: 12, height: 12)
                    
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: 20, height: 20)
                }
                
                // Timeline line
                if !isLast {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 2)
                        .frame(height: 60)
                }
            }
            .frame(width: 80)
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                // Title with icon
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: item.image)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                    
                    Text(item.title)
                        .font(.custom("Futura", size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                
                // Description
                Text(item.description)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Cost badge
                Text(item.cost)
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.1))
                    )
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, isLast ? 0 : 10)
    }
}

// Preview
struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
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
} 