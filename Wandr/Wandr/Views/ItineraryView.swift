//
//  ItineraryView.swift
//  Wandr
//
//  Created by Aryaman Jaiswal on 23/06/25.
//

import SwiftUI
// Models are imported automatically as they're in the same module

struct ItineraryView: View {
    let itinerary: Itinerary
    @Binding var isShowing: Bool
    
    @State private var showDetails = false
    @State private var selectedTab = 0
    @State private var itemAppearDelay = 0.0
    @State private var headerOpacity = 0.0
    @State private var titleScale = 0.9
    
    var body: some View {
        ZStack {
            // Clean black background
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                ScrollView {
                    VStack(spacing: 30) {
                        // Title Section
                        titleSection
                            .padding(.top, 25)
                        
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
                headerOpacity = 1.0
                titleScale = 1.0
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
                .padding(8)
                .padding(.horizontal, 4)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .opacity(headerOpacity)
                )
                .padding(.leading, 12)
            }
            
            Spacer()
            
            Text("your journey")
                .font(.custom("Futura", size: 18))
                .tracking(1)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .opacity(headerOpacity)
            
            Spacer()
            
            Button(action: {
                // Share functionality would go here
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            .opacity(headerOpacity)
                    )
                    .padding(.trailing, 12)
            }
        }
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(Color.black.opacity(0.5))
        )
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(Color.white.opacity(0.2)),
            alignment: .bottom
        )
    }
    
    // Title section with clean style
    private var titleSection: some View {
        VStack(spacing: 16) {
            Text(itinerary.title)
                .font(.custom("Futura", size: 32))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .opacity(showDetails ? 1 : 0)
                .scaleEffect(titleScale)
                .animation(.easeOut.delay(0.1), value: showDetails)
            
            Text(itinerary.subtitle)
                .font(.custom("Futura", size: 16))
                .italic()
                .tracking(1)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
                .opacity(showDetails ? 1 : 0)
                .animation(.easeOut.delay(0.2), value: showDetails)
            
            HStack {
                Text("Budget")
                    .font(.custom("Futura", size: 16))
                    .tracking(1)
                    .foregroundStyle(.white.opacity(0.8))
                
                Text(itinerary.totalCost)
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
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
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .opacity(showDetails ? 1 : 0)
        .animation(.easeOut.delay(0.4), value: showDetails)
    }
    
    // Tab button with clean style
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
                .tracking(0.5)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    selectedTab == index ?
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(2) : nil
                )
                .foregroundStyle(selectedTab == index ? .black : .white.opacity(0.7))
        }
        .scaleEffect(selectedTab == index ? 1.0 : 0.98)
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
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                )
                .opacity(showDetails ? 1 : 0)
                .animation(.easeOut.delay(0.6), value: showDetails)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }
}

// Preview
#Preview {
    let sampleItems = [
        ItineraryItem(
            time: "9:00 AM",
            title: "Beach Morning",
            description: "Start your day at Anjuna Beach",
            cost: "Free",
            image: "sunrise.fill"
        )
    ]
    
    let sampleTransport = [
        TransportOption(type: "Scooter", cost: "₹400", description: "Most flexible")
    ]
    
    let sampleItinerary = Itinerary(
        title: "Goa Beach Day",
        subtitle: "A day of sun and fun",
        totalCost: "₹3800 per person",
        items: sampleItems,
        transportOptions: sampleTransport,
        notes: "Sample notes about the trip"
    )
    
    return ItineraryView(itinerary: sampleItinerary, isShowing: .constant(true))
}