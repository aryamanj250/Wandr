//
//  ItineraryModels.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import Foundation

// Itinerary model
struct Itinerary {
    let title: String
    let subtitle: String
    let totalCost: String
    let items: [ItineraryItem]
    let transportOptions: [TransportOption]
    let notes: String
}

// Itinerary Item model
struct ItineraryItem: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let description: String
    let cost: String
    let image: String
}

// Transport Option model
struct TransportOption: Identifiable {
    let id = UUID()
    let type: String
    let cost: String
    let description: String
}

// Message model
struct Message: Identifiable {
    let id: String
    let text: String
    let isUser: Bool
    let timestamp: Date
} 