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
    let budgetImpact: Double
    let whyRecommended: String
    let currentStatus: String?
    let bookingRequired: Bool
    let notes: String?

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
