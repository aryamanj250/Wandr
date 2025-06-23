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
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))

                Spacer()

                Text("Demo Time")
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue.opacity(0.2))
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            // Timeline items
            VStack(spacing: 0) {
                ForEach(todayTimelineItems) { item in
                    NativeTimelineItemRow(
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
        }
        .sheet(isPresented: $showingDetail) {
            if let item = selectedItem {
                TimelineItemDetailView(item: item)
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
            TimelineItem(time: "9:00", title: "Hotel breakfast", description: "Hotel Maidens breakfast buffet", status: .completed, notes: "Excellent parathas!"),
            TimelineItem(time: "10:30", title: "Hotel checkout", description: "Checked out from Hotel Maidens", status: .completed, notes: "Left luggage at reception"),
            TimelineItem(time: "11:00", title: "India Gate visit", description: "Photo session at India Gate", status: .completed, notes: "Perfect weather for photos"),
            TimelineItem(time: "12:30", title: "Lunch", description: "Paranthe Wali Gali food tour", status: .completed, notes: "Tried 4 different parathas"),
            TimelineItem(time: "2:00", title: "Prep for Red Fort", description: "Preparing for Red Fort visit", status: .current, notes: "Weather looking perfect!"),
            TimelineItem(time: "2:30", title: "Auto to Red Fort", description: "Pre-booked auto-rickshaw", status: .pending, notes: "Agent suggests leaving now"),
            TimelineItem(time: "3:00", title: "Red Fort exploration", description: "Guided tour with pre-booked tickets", status: .pending, notes: nil),
            TimelineItem(time: "5:30", title: "Chandni Chowk", description: "Street food tour", status: .pending, notes: nil),
            TimelineItem(time: "7:30", title: "Dinner at Karim's", description: "Famous mutton korma", status: .pending, notes: "Reservation confirmed")
        ]
    }
}

struct NativeTimelineItemRow: View {
    let item: TimelineItem
    let isCurrent: Bool
    let onTap: () -> Void
    let onMarkDone: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Connecting line (top)
            if item.time != "9:00" {
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 2, height: 20)
                    .offset(x: -140)
            }

            // Main content
            HStack(spacing: 16) {
                // Time
                VStack {
                    Text(item.time)
                        .font(.custom("Futura", size: 14))
                        .fontWeight(.medium)
                        .foregroundStyle(isCurrent ? .blue : .white.opacity(0.8))

                    // Status dot
                    Circle()
                        .fill(item.status.color)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                        .scaleEffect(isCurrent ? 1.5 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isCurrent)
                }
                .frame(width: 60)

                // Content
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(item.title)
                            .font(.custom("Futura", size: isCurrent ? 18 : 16))
                            .fontWeight(isCurrent ? .bold : .medium)
                            .foregroundStyle(.white)

                        Spacer()

                        if item.status == .pending || item.status == .current {
                            Button("Mark Done") {
                                onMarkDone()
                            }
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.blue.opacity(0.2))
                            )
                        }
                    }

                    Text(item.description)
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(isCurrent ? nil : 2)

                    if let notes = item.notes, isCurrent {
                        Text(notes)
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.white.opacity(0.5))
                            .italic()
                    }

                    // Expanded details for current item
                    if isCurrent {
                        VStack(alignment: .leading, spacing: 8) {
                            Divider()
                                .background(.white.opacity(0.2))

                            HStack {
                                Button("View Details") {
                                    onTap()
                                }
                                .font(.custom("Futura", size: 14))
                                .foregroundStyle(.blue)

                                Spacer()

                                if item.status == .current {
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(.green)
                                            .frame(width: 6, height: 6)

                                        Text("In Progress")
                                            .font(.custom("Futura", size: 12))
                                            .foregroundStyle(.green)
                                    }
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, isCurrent ? 16 : 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCurrent ? .blue.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isCurrent ? .blue.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
            .animation(.easeInOut(duration: 0.3), value: isCurrent)

            // Connecting line (bottom)
            if item.time != "7:30" {
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 2, height: 20)
                    .offset(x: -140)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !isCurrent {
                onTap()
            }
        }
    }
}

struct TimelineItemDetailView: View {
    let item: TimelineItem
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                // Assuming ButlerBackground is available globally
                // ButlerBackground().edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text(item.title)
                            .font(.custom("Futura", size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("\(item.time) - \(item.description)")
                            .font(.custom("Futura", size: 16))
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }

                    // Status
                    HStack {
                        Image(systemName: item.status.icon)
                            .foregroundStyle(item.status.color)

                        Text(statusDisplayName(for: item.status))
                            .font(.custom("Futura", size: 16))
                            .foregroundStyle(item.status.color)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(item.status.color.opacity(0.2))
                    )

                    // Notes
                    if let notes = item.notes {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.custom("Futura", size: 18))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)

                            Text(notes)
                                .font(.custom("Futura", size: 14))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.05))
                        )
                    }

                    Spacer()

                    // Actions
                    if item.status == .pending || item.status == .current {
                        Button("Mark as Complete") {
                            // Handle completion
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue)
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Timeline Details")
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

    private func statusDisplayName(for status: TimelineStatus) -> String {
        switch status {
        case .completed: return "Completed"
        case .current: return "In Progress"
        case .pending: return "Pending"
        case .cancelled: return "Cancelled"
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
