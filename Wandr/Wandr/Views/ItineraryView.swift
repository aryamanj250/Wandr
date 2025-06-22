//
//  ItineraryView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI
// Models are imported automatically as they're in the same module

struct ItineraryView: View {
    let itinerary: Itinerary
    @Binding var isShowing: Bool
    
    @State private var showDetails = false
    @State private var selectedTab = 0
    @State private var itemAppearDelay = 0.0
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                ScrollView {
                    VStack(spacing: 30) {
                        // Title Section
                        titleSection
                            .padding(.top, 20)
                        
                        // Tab Selection
                        tabSelectionView
                        
                        // Tab Content
                        tabContentView
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut.delay(0.3)) {
                showDetails = true
            }
        }
    }
    
    // Header view
    private var headerView: some View {
        HStack {
            Button(action: {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    isShowing = false
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Back")
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.medium)
                }
                .foregroundStyle(.white)
                .padding(.leading, 8)
            }
            
            Spacer()
            
            Text("Itinerary")
                .font(.custom("Futura", size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            Spacer()
            
            Button(action: {
                // Share functionality would go here
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 16)
        .background(Color.black.opacity(0.8))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(Color.white.opacity(0.2)),
            alignment: .bottom
        )
    }
    
    // Title section
    private var titleSection: some View {
        VStack(spacing: 12) {
            Text(itinerary.title)
                .font(.custom("Futura", size: 28))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .opacity(showDetails ? 1 : 0)
                .animation(.easeOut.delay(0.1), value: showDetails)
            
            Text(itinerary.subtitle)
                .font(.custom("Futura", size: 16))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
                .opacity(showDetails ? 1 : 0)
                .animation(.easeOut.delay(0.2), value: showDetails)
            
            HStack {
                Text("Total Budget:")
                    .font(.custom("Futura", size: 16))
                    .foregroundStyle(.white.opacity(0.8))
                
                Text(itinerary.totalCost)
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
            .opacity(showDetails ? 1 : 0)
            .animation(.easeOut.delay(0.3), value: showDetails)
        }
    }
    
    // Tab selection view
    private var tabSelectionView: some View {
        HStack(spacing: 0) {
            tabButton(title: "Timeline", index: 0)
            tabButton(title: "Transport", index: 1)
            tabButton(title: "Notes", index: 2)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .opacity(showDetails ? 1 : 0)
        .animation(.easeOut.delay(0.4), value: showDetails)
    }
    
    // Tab button
    private func tabButton(title: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
                resetItemDelay()
            }
        }) {
            Text(title)
                .font(.custom("Futura", size: 15))
                .fontWeight(.medium)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    selectedTab == index ?
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .padding(2) : nil
                )
                .foregroundStyle(selectedTab == index ? .black : .white.opacity(0.7))
        }
    }
    
    // Reset animation delay counter
    private func resetItemDelay() {
        itemAppearDelay = 0.0
    }
    
    // Tab content view
    private var tabContentView: some View {
        Group {
            switch selectedTab {
            case 0:
                timelineView
            case 1:
                transportView
            case 2:
                notesView
            default:
                timelineView
            }
        }
    }
    
    // Timeline view
    private var timelineView: some View {
        TimelineView(items: itinerary.items)
            .padding(.top, 20)
    }
    
    // Transport view
    private var transportView: some View {
        VStack(spacing: 16) {
            ForEach(Array(itinerary.transportOptions.enumerated()), id: \.element.id) { index, option in
                let delay = 0.5 + Double(index) * 0.1
                
                TransportOptionView(option: option)
                    .opacity(showDetails ? 1 : 0)
                    .offset(y: showDetails ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay), value: showDetails)
            }
        }
        .padding(.top, 20)
    }
    
    // Notes view
    private var notesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trip Notes")
                .font(.custom("Futura", size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.top, 10)
                .opacity(showDetails ? 1 : 0)
                .animation(.easeOut.delay(0.5), value: showDetails)
            
            Text(itinerary.notes)
                .font(.custom("Futura", size: 16))
                .foregroundStyle(.white.opacity(0.9))
                .lineSpacing(6)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                )
                .opacity(showDetails ? 1 : 0)
                .animation(.easeOut.delay(0.6), value: showDetails)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }
}

// Itinerary Item View
struct ItineraryItemView: View {
    let item: ItineraryItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Time column
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .frame(width: 24, height: 24)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                }
                
                Text(item.time)
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(width: 60)
                    .multilineTextAlignment(.center)
            }
            
            // Content column
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: item.image)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                    
                    Text(item.title)
                        .font(.custom("Futura", size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                
                Text(item.description)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.8))
                    .lineSpacing(4)
                
                Text(item.cost)
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.05))
                    )
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
}

// Transport Option View
struct TransportOptionView: View {
    let option: TransportOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: transportIcon)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                
                Text(option.type)
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            
            Text(option.description)
                .font(.custom("Futura", size: 14))
                .foregroundStyle(.white.opacity(0.8))
            
            Text(option.cost)
                .font(.custom("Futura", size: 14))
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                )
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
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



#Preview {
    ItineraryView(
        itinerary: Itinerary(
            title: "Goa Beach Day",
            subtitle: "A budget-friendly day of beaches and beer",
            totalCost: "₹3800 per person (approx.)",
            items: [
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
                )
            ],
            transportOptions: [
                TransportOption(
                    type: "Rented Scooters",
                    cost: "₹400 per day per scooter",
                    description: "Most flexible option"
                )
            ],
            notes: "Prices are approximate. This itinerary keeps you under your budget."
        ),
        isShowing: .constant(true)
    )
} 