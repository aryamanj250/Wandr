//
//  NativeTimelineView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct NativeTimelineView: View {
    let trip: UpcomingTrip
    @State private var selectedItem: TimelineItem? = nil
    @State private var showingDetail = false

    var body: some View {
        VStack(spacing: 0) {
            // Current time indicator
            HStack {
                Text("2:00 PM - Day 3")
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Spacer()

                HStack(spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 6, height: 6)

                    Text("Live Updates")
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.green)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.green.opacity(0.2))
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            // Timeline items
            VStack(spacing: 16) {
                ForEach(todayTimelineItems) { item in
                    ProfessionalTimelineItemRow(
                        item: item,
                        isCurrent: item.id == currentTimelineItem?.id,
                        onTap: {
                            selectedItem = item
                            showingDetail = true
                        },
                        onMarkDone: {
                            markItemDone(item)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showingDetail) {
            if let item = selectedItem {
                EnhancedTimelineDetailView(item: item)
            }
        }
    }

    var currentTimelineItem: TimelineItem? {
        // Demo logic: Item at 2:00 PM is current
        return todayTimelineItems.first { $0.time == "2:00" }
    }

    private func markItemDone(_ item: TimelineItem) {
        // Handle marking item as done
        print("Marked as done: \(item.title)")
    }

    var todayTimelineItems: [TimelineItem] {
        [
            TimelineItem(
                time: "9:00",
                title: "Hotel Breakfast",
                description: "Authentic Indian breakfast buffet",
                status: .completed,
                notes: "Excellent parathas and fresh lassi!",
                location: "Hotel Maidens",
                address: "5, Sham Nath Marg, Civil Lines, Delhi 110054",
                duration: "1 hour",
                cost: "Included in stay",
                howToReach: "In-house restaurant on ground floor",
                tips: ["Try the aloo paratha", "Fresh fruit selection available", "Chai served till 10:30 AM"],
                contact: "+91 11 2397 5464",
                category: .meal
            ),
            TimelineItem(
                time: "10:30",
                title: "Hotel Checkout",
                description: "Complete checkout and luggage storage",
                status: .completed,
                notes: "Left luggage at reception for day exploration",
                location: "Hotel Maidens Reception",
                address: "5, Sham Nath Marg, Civil Lines, Delhi 110054",
                duration: "30 minutes",
                cost: "No additional cost",
                howToReach: "Main reception area",
                tips: ["Keep valuables with you", "Luggage storage is complimentary", "Collect receipt for luggage"],
                contact: "+91 11 2397 5464",
                category: .accommodation
            ),
            TimelineItem(
                time: "11:00",
                title: "India Gate Visit",
                description: "Iconic war memorial and photography",
                status: .completed,
                notes: "Perfect weather for photos and morning walk",
                location: "India Gate",
                address: "Rajpath, India Gate, New Delhi, Delhi 110001",
                duration: "1.5 hours",
                cost: "Free entry",
                howToReach: "15 min walk from hotel or ₹50 auto-rickshaw",
                tips: ["Best lighting for photos before noon", "Street vendors sell cold drinks", "Avoid weekend crowds"],
                contact: "No contact required",
                category: .sightseeing
            ),
            TimelineItem(
                time: "12:30",
                title: "Paranthe Wali Gali",
                description: "Famous street food experience",
                status: .completed,
                notes: "Tried 4 different parathas - amazing flavors!",
                location: "Paranthe Wali Gali",
                address: "Gali Paranthe Wali, Chandni Chowk, Old Delhi, Delhi 110006",
                duration: "1 hour",
                cost: "₹200-300 per person",
                howToReach: "Metro to Chandni Chowk, then 5 min walk",
                tips: ["Try mixed vegetable paratha", "Order lassi to cool down", "Cash only - no cards accepted"],
                contact: "Multiple vendors available",
                category: .meal
            ),
            TimelineItem(
                time: "2:00",
                title: "Red Fort Preparation",
                description: "Getting ready for the main attraction",
                status: .current,
                notes: "Weather is perfect! All tickets confirmed.",
                location: "Nearby Café",
                address: "Near Red Fort Metro Station",
                duration: "30 minutes",
                cost: "₹100 for refreshments",
                howToReach: "Already at location",
                tips: ["Use restroom before entry", "Carry water bottle", "Wear comfortable walking shoes"],
                contact: "N/A",
                category: .activity
            ),
            TimelineItem(
                time: "2:30",
                title: "Auto to Red Fort",
                description: "Pre-booked auto-rickshaw ride",
                status: .pending,
                notes: "Agent suggests leaving now to avoid traffic",
                location: "From current location to Red Fort",
                address: "Netaji Subhash Marg, Chandni Chowk, New Delhi, Delhi 110006",
                duration: "15 minutes",
                cost: "₹80 (pre-negotiated)",
                howToReach: "Auto-rickshaw pickup at designated spot",
                tips: ["Driver has been briefed", "Keep small change ready", "Traffic might be heavy"],
                contact: "Driver: +91 98765 43210",
                category: .transport
            ),
            TimelineItem(
                time: "3:00",
                title: "Red Fort Exploration",
                description: "UNESCO World Heritage Site guided tour",
                status: .pending,
                notes: nil,
                location: "Red Fort (Lal Qila)",
                address: "Netaji Subhash Marg, Chandni Chowk, New Delhi, Delhi 110006",
                duration: "2 hours",
                cost: "₹35 entry + ₹500 guide",
                howToReach: "5 minute walk from auto drop-off point",
                tips: [
                    "Carry ID for entry verification",
                    "Photography allowed in most areas",
                    "Visit Diwan-i-Khas for best Mughal architecture",
                    "Don't miss the evening sound & light show",
                    "Wear comfortable shoes - lots of walking",
                    "Best photo spots: Lahori Gate, Throne of Shah Jahan",
                    "Avoid touching ancient walls and structures",
                    "Guided tour includes Mumtaz Mahal museum"
                ],
                contact: "Tourist Helpline: +91 11 2336 5358",
                category: .sightseeing
            ),
            TimelineItem(
                time: "5:30",
                title: "Chandni Chowk Exploration",
                description: "Historic market and street food tour",
                status: .pending,
                notes: nil,
                location: "Chandni Chowk Market",
                address: "Chandni Chowk, Old Delhi, Delhi 110006",
                duration: "1.5 hours",
                cost: "₹300-500 for shopping & snacks",
                howToReach: "10 minute walk from Red Fort",
                tips: ["Try jalebi at Old Famous Jalebi Wala", "Bargain is expected", "Keep belongings secure"],
                contact: "Market association: +91 11 2327 8001",
                category: .activity
            ),
            TimelineItem(
                time: "7:30",
                title: "Dinner at Karim's",
                description: "Historic Mughlai cuisine restaurant",
                status: .pending,
                notes: "Reservation confirmed for mutton korma",
                location: "Karim's Restaurant",
                address: "16, Gali Kababian, Near Jama Masjid, Delhi 110006",
                duration: "1.5 hours",
                cost: "₹800-1000 for two people",
                howToReach: "15 minute walk from Chandni Chowk",
                tips: ["Famous for mutton korma and kebabs", "No alcohol served", "Cash preferred"],
                contact: "+91 11 2326 9880",
                category: .meal
            )
        ]
    }
}

struct ProfessionalTimelineItemRow: View {
    let item: TimelineItem
    let isCurrent: Bool
    let onTap: () -> Void
    let onMarkDone: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            // Timeline connector
            VStack(spacing: 0) {
                // Top line
                if item.time != "9:00" {
                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 2, height: 20)
                }

                // Status indicator
                ZStack {
                    Circle()
                        .fill(item.status.color)
                        .frame(width: isCurrent ? 16 : 12, height: isCurrent ? 16 : 12)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                        .scaleEffect(isCurrent ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isCurrent)

                    if isCurrent {
                        Circle()
                            .stroke(item.status.color.opacity(0.4), lineWidth: 4)
                            .frame(width: 24, height: 24)
                            .scaleEffect(1.5)
                    }
                }

                // Bottom line
                if item.time != "7:30" {
                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 2, height: 20)
                }
            }
            .frame(width: 40)

            // Content
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(item.time)
                                .font(.custom("Futura", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(isCurrent ? .blue : .white.opacity(0.9))

                            Image(systemName: item.category.icon)
                                .font(.system(size: 12))
                                .foregroundStyle(item.category.color)
                        }

                        Text(item.title)
                            .font(.custom("Futura", size: isCurrent ? 18 : 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    if item.status == .pending || item.status == .current {
                        Button("Mark Done") {
                            onMarkDone()
                        }
                        .font(.custom("Futura", size: 11))
                        .fontWeight(.medium)
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.blue.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.blue.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }

                // Description and details
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.description)
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(isCurrent ? nil : 2)

                    if let location = item.location {
                        HStack(spacing: 6) {
                            Image(systemName: "location")
                                .font(.system(size: 12))
                                .foregroundStyle(.white.opacity(0.6))

                            Text(location)
                                .font(.custom("Futura", size: 12))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }

                    if let duration = item.duration, let cost = item.cost {
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.6))
                                Text(duration)
                                    .font(.custom("Futura", size: 11))
                                    .foregroundStyle(.white.opacity(0.7))
                            }

                            HStack(spacing: 4) {
                                Image(systemName: "indianrupeesign.circle")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.6))
                                Text(cost)
                                    .font(.custom("Futura", size: 11))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                    }

                    if let notes = item.notes, isCurrent {
                        Text(notes)
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.green)
                            .italic()
                            .padding(.top, 4)
                    }
                }

                // Action button for details
                if isCurrent || item.status == .pending {
                    Button(action: onTap) {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 12))

                            Text("View Details & Tips")
                                .font(.custom("Futura", size: 12))
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.blue)
                        .padding(.top, 8)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.leading, 12)
        }
        .padding(.vertical, isCurrent ? 20 : 16)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isCurrent ? .blue.opacity(0.08) : .white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isCurrent ? .blue.opacity(0.2) : .white.opacity(0.1), lineWidth: 1)
                )
        )
        .animation(.easeInOut(duration: 0.3), value: isCurrent)
        .onTapGesture {
            if !isCurrent {
                onTap()
            }
        }
    }
}

struct EnhancedTimelineDetailView: View {
    let item: TimelineItem
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: item.category.icon)
                                    .font(.system(size: 24))
                                    .foregroundStyle(item.category.color)

                                Spacer()

                                Text(item.time)
                                    .font(.custom("Futura", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.blue)
                            }

                            Text(item.title)
                                .font(.custom("Futura", size: 28))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)

                            Text(item.description)
                                .font(.custom("Futura", size: 16))
                                .foregroundStyle(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(item.category.color.opacity(0.3), lineWidth: 1)
                                )
                        )

                        // Location & Logistics
                        if let location = item.location {
                            InfoSection(
                                title: "Location Details",
                                icon: "location.fill",
                                color: .blue
                            ) {
                                InfoRow(label: "Venue", value: location)
                                if let address = item.address {
                                    InfoRow(label: "Address", value: address)
                                }
                                if let duration = item.duration {
                                    InfoRow(label: "Duration", value: duration)
                                }
                                if let cost = item.cost {
                                    InfoRow(label: "Cost", value: cost)
                                }
                                if let contact = item.contact {
                                    InfoRow(label: "Contact", value: contact)
                                }
                            }
                        }

                        // How to Reach
                        if let howToReach = item.howToReach {
                            InfoSection(
                                title: "How to Reach",
                                icon: "arrow.triangle.turn.up.right.diamond",
                                color: .green
                            ) {
                                Text(howToReach)
                                    .font(.custom("Futura", size: 14))
                                    .foregroundStyle(.white.opacity(0.9))
                                    .lineSpacing(4)
                            }
                        }

                        // Tips & Recommendations
                        if let tips = item.tips, !tips.isEmpty {
                            InfoSection(
                                title: "Tips & Recommendations",
                                icon: "lightbulb.fill",
                                color: .yellow
                            ) {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                                        HStack(alignment: .top, spacing: 8) {
                                            Circle()
                                                .fill(.yellow.opacity(0.7))
                                                .frame(width: 6, height: 6)
                                                .offset(y: 6)

                                            Text(tip)
                                                .font(.custom("Futura", size: 14))
                                                .foregroundStyle(.white.opacity(0.9))
                                                .lineSpacing(4)
                                        }
                                    }
                                }
                            }
                        }

                        // Notes
                        if let notes = item.notes {
                            InfoSection(
                                title: "Personal Notes",
                                icon: "note.text",
                                color: .purple
                            ) {
                                Text(notes)
                                    .font(.custom("Futura", size: 14))
                                    .foregroundStyle(.white.opacity(0.9))
                                    .italic()
                                    .lineSpacing(4)
                            }
                        }

                        // Action Buttons
                        if item.status == .pending || item.status == .current {
                            VStack(spacing: 12) {
                                Button("Mark as Completed") {
                                    // Handle completion
                                    presentationMode.wrappedValue.dismiss()
                                }
                                .font(.custom("Futura", size: 16))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.green)
                                )

                                if item.address != nil {
                                    Button("Open in Maps") {
                                        // Handle maps opening
                                    }
                                    .font(.custom("Futura", size: 14))
                                    .fontWeight(.medium)
                                    .foregroundStyle(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.blue.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(.blue.opacity(0.4), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Activity Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content

    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(color)

                Text(title)
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }

            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.custom("Futura", size: 14))
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.7))
                .frame(width: 80, alignment: .leading)

            Text(value)
                .font(.custom("Futura", size: 14))
                .foregroundStyle(.white.opacity(0.9))

            Spacer()
        }
    }
}

#Preview {
    NativeTimelineView(trip: UpcomingTrip(
        destination: "Delhi Heritage Tour",
        departureDate: Date(),
        returnDate: Date(),
        duration: "3 days",
        status: .inProgress,
        imageUrl: nil,
        budget: "₹15,000",
        companions: 2,
        participants: ["You", "Sarah"],
        progress: TripProgress(
            totalSteps: 10,
            completedSteps: 8,
            currentAction: "Preparing for Red Fort visit",
            nextAction: "Red Fort exploration at 3:00 PM",
            estimatedCompletion: "Day 3 of 3 - Final day"
        ),
        bookings: TripBookings(flights: nil, hotels: [], selectedHotel: nil, transport: [], activities: []),
        notes: "Day 3 of 3"
    ))
}
