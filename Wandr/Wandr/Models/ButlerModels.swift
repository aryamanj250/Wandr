//
//  ButlerModels.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import Foundation

// Butler Task model
struct ButlerTask: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let priority: TaskPriority
    let dueTime: String?
    let category: ButlerTaskCategory
    let actionable: Bool
    let icon: String
    let estimatedDuration: String?
}

enum TaskPriority: String, CaseIterable {
    case urgent = "urgent"
    case high = "high"
    case medium = "medium"
    case low = "low"
    
    var color: String {
        switch self {
        case .urgent: return "red"
        case .high: return "orange"
        case .medium: return "yellow"
        case .low: return "green"
        }
    }
}

enum ButlerTaskCategory: String, CaseIterable {
    case travel = "travel"
    case dining = "dining"
    case transport = "transport"
    case reminder = "reminder"
    case meeting = "meeting"
    case personal = "personal"
    
    var icon: String {
        switch self {
        case .travel: return "airplane"
        case .dining: return "fork.knife"
        case .transport: return "car.fill"
        case .reminder: return "bell.fill"
        case .meeting: return "calendar"
        case .personal: return "person.fill"
        }
    }
}

// Enhanced Trip model
struct UpcomingTrip: Identifiable {
    let id = UUID()
    let destination: String
    let departureDate: Date
    let returnDate: Date
    let duration: String
    let status: TripStatus
    let imageUrl: String?
    let budget: String?
    let companions: Int
    let participants: [String]
    let progress: TripProgress
    let bookings: TripBookings
    let notes: String?
}

// Trip Progress model
struct TripProgress {
    let totalSteps: Int
    let completedSteps: Int
    let currentAction: String?
    let nextAction: String?
    let estimatedCompletion: String?
    
    var progressPercentage: Double {
        return Double(completedSteps) / Double(totalSteps)
    }
}

// Trip Bookings model
struct TripBookings {
    var flights: FlightBooking?
    var hotels: [HotelOption]
    var selectedHotel: HotelOption?
    var transport: [TransportBooking]
    var activities: [ActivityBooking]
}

// Flight Booking model
struct FlightBooking: Identifiable {
    let id = UUID()
    let airline: String
    let flightNumber: String
    let departure: FlightSegment
    let arrival: FlightSegment
    let price: String
    let status: BookingStatus
    let bookingReference: String?
}

struct FlightSegment {
    let airport: String
    let airportCode: String
    let time: Date
    let terminal: String?
}

// Hotel Option model
struct HotelOption: Identifiable {
    let id = UUID()
    let name: String
    let rating: Double
    let pricePerNight: String
    let totalPrice: String
    let location: String
    let amenities: [String]
    let images: [String]
    let checkIn: Date
    let checkOut: Date
    let roomType: String
    let isRecommended: Bool
    let distance: String
}

// Transport Booking model
struct TransportBooking: Identifiable {
    let id = UUID()
    let type: TransportType
    let from: String
    let to: String
    let time: Date
    let price: String
    let status: BookingStatus
    let details: String
}

enum TransportType: String, CaseIterable {
    case taxi = "Taxi"
    case bus = "Bus"
    case train = "Train"
    case rental = "Car Rental"
    case uber = "Uber"
}

// Activity Booking model
struct ActivityBooking: Identifiable {
    let id = UUID()
    let name: String
    let type: ActivityType
    let date: Date
    let duration: String
    let price: String
    let location: String
    let description: String
    let status: BookingStatus
}

enum ActivityType: String, CaseIterable {
    case sightseeing = "Sightseeing"
    case adventure = "Adventure"
    case dining = "Dining"
    case cultural = "Cultural"
    case relaxation = "Relaxation"
}

enum BookingStatus: String, CaseIterable {
    case searching = "Searching"
    case found = "Found Options"
    case booking = "Booking"
    case confirmed = "Confirmed"
    case failed = "Failed"
}

// Alfred Action model
struct AlfredAction: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let status: ActionStatus
    let progress: Double
    let estimatedTime: String?
    let steps: [ActionStep]
    let result: ActionResult?
}

struct ActionStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let isCompleted: Bool
    let isActive: Bool
    let duration: String?
}

struct ActionResult {
    let success: Bool
    let message: String
    let data: [String: String]?
    let nextActions: [String]?
}

enum ActionStatus: String, CaseIterable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"
    case failed = "Failed"
    case waiting = "Waiting for User"
}

enum TripStatus: String, CaseIterable {
    case planning = "planning"
    case booked = "booked"
    case confirmed = "confirmed"
    case inProgress = "in_progress"
    
    var displayName: String {
        switch self {
        case .planning: return "Planning"
        case .booked: return "Booked"
        case .confirmed: return "Confirmed"
        case .inProgress: return "In Progress"
        }
    }
}

// Quick Action model
struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let action: ActionType
    let value: String?
}

enum ActionType: String, CaseIterable {
    case weather = "weather"
    case calendar = "calendar"
    case traffic = "traffic"
    case reminders = "reminders"
    case notes = "notes"
    case contacts = "contacts"
}

// Butler Greeting model
struct ButlerGreeting {
    let message: String
    let timeOfDay: TimeOfDay
    let suggestion: String?
}

enum TimeOfDay: String, CaseIterable {
    case morning = "morning"
    case afternoon = "afternoon"
    case evening = "evening"
    case night = "night"
    
    static func current() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return .morning
        case 12..<17: return .afternoon
        case 17..<21: return .evening
        default: return .night
        }
    }
}