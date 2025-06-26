//
//  ItineraryView.swift
//  Wandr
//
//  Created by Aryaman Jaiswal on 23/06/25.
//

import SwiftUI

struct ItineraryView: View {
    let itineraryResponse: ItineraryResponse
    @Binding var isShowing: Bool
    
    @State private var showDetails = false
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
                        
                        // Tab Content (only Timeline now)
                        timelineView
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
            Text(itineraryResponse.parsedCommand?.location ?? "Your Journey")
                .font(.custom("Futura", size: 32))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .opacity(showDetails ? 1 : 0)
                .scaleEffect(titleScale)
                .animation(.easeOut.delay(0.1), value: showDetails)
            
            Text(itineraryResponse.timelineSuggestion)
                .font(.custom("Futura", size: 16))
                .italic()
                .tracking(1)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
                .opacity(showDetails ? 1 : 0)
                .animation(.easeOut.delay(0.2), value: showDetails)
            
            HStack {
                Text("Estimated Cost")
                    .font(.custom("Futura", size: 16))
                    .tracking(1)
                    .foregroundStyle(.white.opacity(0.8))
                
                Text("$\(itineraryResponse.totalEstimatedCost, specifier: "%.0f")")
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
    
    // Timeline view
    private var timelineView: some View {
        TimelineView(items: itineraryResponse.itinerary)
            .padding(.top, 20)
    }
}

// Preview
#Preview {
    let sampleParsedCommand = ParsedCommand(
        location: "Goa",
        budget: 5000,
        durationHours: 8,
        preferences: ["beach vibes", "party"],
        groupSize: 2,
        specialRequirements: nil
    )
    
    let sampleItineraryItems = [
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
                notes: nil,
                cuisine: nil,
                mealType: nil
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
                notes: "Try their apple crumble.",
                cuisine: "German",
                mealType: "Breakfast"
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
                notes: "Bargaining is key!",
                cuisine: nil,
                mealType: nil
            )
        ]
    
    let sampleItineraryResponse = ItineraryResponse(
        parsedCommand: sampleParsedCommand,
        itinerary: sampleItineraryItems,
        totalEstimatedCost: 1200,
        timelineSuggestion: "Start at 6 AM, beach morning, breakfast, then market exploration."
    )
    
    ItineraryView(itineraryResponse: sampleItineraryResponse, isShowing: .constant(true))
}
