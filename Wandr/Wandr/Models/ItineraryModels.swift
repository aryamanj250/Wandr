//
//  ItineraryModels.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import Foundation

// MARK: - Top-level Itinerary Response Model
struct ItineraryResponse: Codable {
    let parsedCommand: ParsedCommand?
    let itinerary: [ItineraryItem]
    let totalEstimatedCost: Double
    let timelineSuggestion: String

    enum CodingKeys: String, CodingKey {
        case parsedCommand = "parsed_command"
        case itinerary
        case totalEstimatedCost = "total_estimated_cost"
        case timelineSuggestion = "timeline_suggestion"
    }
}

// MARK: - Parsed Command Model
struct ParsedCommand: Codable {
    let location: String?
    let budget: Double?
    let durationHours: Double?
    let preferences: [String]?
    let groupSize: Int?
    let specialRequirements: String?

    enum CodingKeys: String, CodingKey {
        case location
        case budget
        case durationHours = "duration_hours"
        case preferences
        case groupSize = "group_size"
        case specialRequirements = "special_requirements"
    }
}

// MARK: - Itinerary Item Model
struct ItineraryItem: Codable, Identifiable {
    let id: String
    let day: Int
    let name: String
    let type: String
    let location: String
    let description: String
    let time: String
    let rating: Double?
    let priceRange: String?
    let budgetImpact: Double?
    let whyRecommended: String
    let currentStatus: String?
    let bookingRequired: Bool
    let notes: String?
    let cuisine: String?
    let mealType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case day
        case name
        case type
        case location
        case description
        case time
        case rating
        case priceRange = "price_range"
        case budgetImpact = "budget_impact"
        case whyRecommended = "why_recommended"
        case currentStatus = "current_status"
        case bookingRequired = "booking_required"
        case notes
        case cuisine
        case mealType = "meal_type"
    }

    init(id: String, day: Int, name: String, type: String, location: String, description: String, time: String, rating: Double?, priceRange: String?, budgetImpact: Double?, whyRecommended: String, currentStatus: String?, bookingRequired: Bool, notes: String?, cuisine: String?, mealType: String?) {
        self.id = id
        self.day = day
        self.name = name
        self.type = type
        self.location = location
        self.description = description
        self.time = time
        self.rating = rating
        self.priceRange = priceRange
        self.budgetImpact = budgetImpact
        self.whyRecommended = whyRecommended
        self.currentStatus = currentStatus
        self.bookingRequired = bookingRequired
        self.notes = notes
        self.cuisine = cuisine
        self.mealType = mealType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        day = try container.decode(Int.self, forKey: .day)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        location = try container.decode(String.self, forKey: .location)
        description = try container.decode(String.self, forKey: .description)
        time = try container.decode(String.self, forKey: .time)
        // Handle rating which can be a string or number
        if let ratingString = try? container.decodeIfPresent(String.self, forKey: .rating) {
            rating = Double(ratingString)
        } else {
            rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        }
        priceRange = try container.decodeIfPresent(String.self, forKey: .priceRange)
        budgetImpact = try container.decodeIfPresent(Double.self, forKey: .budgetImpact)
        // Handle whyRecommended gracefully if key is missing
        whyRecommended = try container.decodeIfPresent(String.self, forKey: .whyRecommended) ?? "Recommended activity"
        currentStatus = try container.decodeIfPresent(String.self, forKey: .currentStatus)
        // Handle bookingRequired which can be a boolean or integer (0/1)
        if let boolValue = try? container.decodeIfPresent(Bool.self, forKey: .bookingRequired) {
            bookingRequired = boolValue
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: .bookingRequired) {
            bookingRequired = intValue != 0
        } else {
            bookingRequired = false
        }
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        cuisine = try container.decodeIfPresent(String.self, forKey: .cuisine)
        mealType = try container.decodeIfPresent(String.self, forKey: .mealType)
    }
}

// MARK: - Gemini API Response Models
struct GeminiAPIResponse: Codable {
    let candidates: [Candidate]
    let usageMetadata: UsageMetadata?
    let modelVersion: String?
    let responseId: String?

    enum CodingKeys: String, CodingKey {
        case candidates
        case usageMetadata = "usageMetadata"
        case modelVersion = "modelVersion"
        case responseId = "responseId"
    }
}

struct Candidate: Codable {
    let content: GeminiContent
    let finishReason: String?
    let avgLogprobs: Double?

    enum CodingKeys: String, CodingKey {
        case content
        case finishReason
        case avgLogprobs
    }
}

struct GeminiContent: Codable {
    let parts: [Part]
    let role: String?
}

struct Part: Codable {
    let text: String?
}

struct UsageMetadata: Codable {
    let promptTokenCount: Int?
    let candidatesTokenCount: Int?
    let totalTokenCount: Int?
    let promptTokensDetails: [TokenDetails]?
    let candidatesTokensDetails: [TokenDetails]?
}

struct TokenDetails: Codable {
    let modality: String?
    let tokenCount: Int?
}

// MARK: - Message model (Existing, kept for compatibility)
struct Message: Identifiable {
    let id: String
    let text: String
    let isUser: Bool
    let timestamp: Date
}
