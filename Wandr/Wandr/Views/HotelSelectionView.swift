//
//  HotelSelectionView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct HotelSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedHotel: HotelOption?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                ButlerBackground()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerSection
                        
                        // Hotel options
                        VStack(spacing: 16) {
                            ForEach(sampleHotelOptions) { hotel in
                                HotelOptionCard(
                                    hotel: hotel,
                                    isSelected: selectedHotel?.id == hotel.id
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedHotel = hotel
                                    }
                                }
                            }
                        }
                        
                        // Book button
                        if selectedHotel != nil {
                            bookingSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Help") {
                        // Show help
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Choose Your Hotel")
                .font(.custom("Futura", size: 24))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Alfred found these great options based on your preferences for beachfront location and group activities")
                .font(.custom("Futura", size: 16))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
            
            // Trip details
            HStack(spacing: 16) {
                DetailChip(icon: "calendar", text: "Dec 15-19")
                DetailChip(icon: "person.3.fill", text: "4 guests")
                DetailChip(icon: "bed.double.fill", text: "2 rooms")
            }
        }
        .padding(.top, 20)
    }
    
    private var bookingSection: some View {
        VStack(spacing: 16) {
            if let hotel = selectedHotel {
                VStack(spacing: 12) {
                    HStack {
                        Text("Selected: \(hotel.name)")
                            .font(.custom("Futura", size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Spacer()
                        Text(hotel.totalPrice)
                            .font(.custom("Futura", size: 16))
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }
                    
                    Text("Total for 4 nights • Includes breakfast")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.green.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.green.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            
            Button(action: {
                bookSelectedHotel()
            }) {
                HStack {
                    Text("Book with Alfred")
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.medium)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14))
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                        .shadow(color: .white.opacity(0.2), radius: 5, x: 0, y: 2)
                )
            }
            .buttonStyle(ScaleButtonStyle())
            .disabled(selectedHotel == nil)
            .opacity(selectedHotel == nil ? 0.5 : 1.0)
        }
    }
    
    private func bookSelectedHotel() {
        // Simulate booking process
        presentationMode.wrappedValue.dismiss()
    }
    
    private var sampleHotelOptions: [HotelOption] {
        [
            HotelOption(
                name: "Taj Resort & Spa",
                rating: 4.8,
                pricePerNight: "₹6,500",
                totalPrice: "₹26,000",
                location: "Baga Beach",
                amenities: ["Beachfront", "Pool", "Spa", "Restaurant", "WiFi"],
                images: [],
                checkIn: Calendar.current.date(byAdding: .day, value: 12, to: Date()) ?? Date(),
                checkOut: Calendar.current.date(byAdding: .day, value: 16, to: Date()) ?? Date(),
                roomType: "Deluxe Sea View",
                isRecommended: true,
                distance: "50m from beach"
            ),
            HotelOption(
                name: "Casa De Goa",
                rating: 4.5,
                pricePerNight: "₹4,200",
                totalPrice: "₹16,800",
                location: "Calangute",
                amenities: ["Pool", "Restaurant", "Free Breakfast", "WiFi", "AC"],
                images: [],
                checkIn: Calendar.current.date(byAdding: .day, value: 12, to: Date()) ?? Date(),
                checkOut: Calendar.current.date(byAdding: .day, value: 16, to: Date()) ?? Date(),
                roomType: "Standard Double",
                isRecommended: false,
                distance: "200m from beach"
            ),
            HotelOption(
                id: UUID(),
                name: "Blue Waves Resort",
                rating: 4.6,
                pricePerNight: "₹5,800",
                totalPrice: "₹23,200",
                location: "Anjuna Beach",
                amenities: ["Beachfront", "Pool", "Water Sports", "Restaurant", "Bar"],
                images: [],
                checkIn: Calendar.current.date(byAdding: .day, value: 12, to: Date()) ?? Date(),
                checkOut: Calendar.current.date(byAdding: .day, value: 16, to: Date()) ?? Date(),
                roomType: "Beach Villa",
                isRecommended: false,
                distance: "Direct beach access"
            )
        ]
    }
}

struct HotelOptionCard: View {
    let hotel: HotelOption
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(hotel.name)
                                .font(.custom("Futura", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            if hotel.isRecommended {
                                Text("RECOMMENDED")
                                    .font(.custom("Futura", size: 10))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.orange)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(.orange.opacity(0.2))
                                    )
                            }
                        }
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                ForEach(0..<Int(hotel.rating), id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.yellow)
                                }
                                Text(String(format: "%.1f", hotel.rating))
                                    .font(.custom("Futura", size: 12))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            
                            Text("•")
                                .foregroundStyle(.white.opacity(0.5))
                            
                            Text(hotel.location)
                                .font(.custom("Futura", size: 12))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        
                        Text(hotel.distance)
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.blue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(hotel.pricePerNight)
                            .font(.custom("Futura", size: 18))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("per night")
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.white.opacity(0.6))
                        
                        Text(hotel.totalPrice)
                            .font(.custom("Futura", size: 14))
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                    }
                }
                
                // Room type
                HStack {
                    Text(hotel.roomType)
                        .font(.custom("Futura", size: 14))
                        .fontWeight(.medium)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Spacer()
                }
                
                // Amenities
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    ForEach(hotel.amenities.prefix(6), id: \.self) { amenity in
                        Text(amenity)
                            .font(.custom("Futura", size: 11))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.1))
                            )
                    }
                }
            }
            .padding(20)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(isSelected ? 0.1 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? .white.opacity(0.4) : .white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: isSelected ? .white.opacity(0.1) : .clear, radius: isSelected ? 5 : 0, x: 0, y: 2)
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct DetailChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.7))
            
            Text(text)
                .font(.custom("Futura", size: 12))
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.white.opacity(0.1))
        )
    }
}

#Preview {
    HotelSelectionView()
}