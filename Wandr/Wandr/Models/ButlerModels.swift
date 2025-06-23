//
//  ButlerModels.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import Foundation
import SwiftUI

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
    let id: UUID
    let airline: String
    let flightNumber: String
    let departure: FlightSegment
    let arrival: FlightSegment
    let price: String
    let status: BookingStatus
    let bookingReference: String?
    
    init(airline: String, flightNumber: String, departure: FlightSegment, arrival: FlightSegment, price: String, status: BookingStatus, bookingReference: String? = nil) {
        self.id = UUID()
        self.airline = airline
        self.flightNumber = flightNumber
        self.departure = departure
        self.arrival = arrival
        self.price = price
        self.status = status
        self.bookingReference = bookingReference
    }
}

struct FlightSegment {
    let airport: String
    let airportCode: String
    let time: Date
    let terminal: String?
}

// Hotel Option model
struct HotelOption: Identifiable {
    let id: UUID
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
    
    init(name: String, rating: Double, pricePerNight: String, totalPrice: String, location: String, amenities: [String], images: [String], checkIn: Date, checkOut: Date, roomType: String, isRecommended: Bool, distance: String) {
        self.id = UUID()
        self.name = name
        self.rating = rating
        self.pricePerNight = pricePerNight
        self.totalPrice = totalPrice
        self.location = location
        self.amenities = amenities
        self.images = images
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.roomType = roomType
        self.isRecommended = isRecommended
        self.distance = distance
    }
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
    let id: UUID
    let title: String
    let description: String
    let isCompleted: Bool
    let isActive: Bool
    let duration: String?
    
    init(title: String, description: String, isCompleted: Bool, isActive: Bool, duration: String? = nil) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.isActive = isActive
        self.duration = duration
    }
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

// MARK: - Agent System Models

// Agent Activity model for live tracking
struct AgentActivity: Identifiable {
    let id = UUID()
    let agentType: AgentType
    let status: AgentStatus
    let currentTask: String
    let lastUpdate: String
    let progress: Double
}

// Agent Types
enum AgentType: String, CaseIterable {
    case weather = "Weather"
    case traffic = "Traffic"
    case restaurant = "Restaurant"
    case booking = "Booking"
    case flight = "Flight"
    case hotel = "Hotel"
    case activity = "Activity"
    case transport = "Transport"
    
    var icon: String {
        switch self {
        case .weather: return "cloud.sun.fill"
        case .traffic: return "car.fill"
        case .restaurant: return "fork.knife"
        case .booking: return "calendar.badge.plus"
        case .flight: return "airplane"
        case .hotel: return "building.2.fill"
        case .activity: return "star.fill"
        case .transport: return "bus.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .weather: return .blue
        case .traffic: return .orange
        case .restaurant: return .green
        case .booking: return .purple
        case .flight: return .blue
        case .hotel: return .cyan
        case .activity: return .yellow
        case .transport: return .indigo
        }
    }
    
    var shortName: String {
        switch self {
        case .weather: return "Weather"
        case .traffic: return "Traffic"
        case .restaurant: return "Food"
        case .booking: return "Book"
        case .flight: return "Flight"
        case .hotel: return "Hotel"
        case .activity: return "Fun"
        case .transport: return "Move"
        }
    }
}

// Agent Status
enum AgentStatus: String, CaseIterable {
    case active = "Active"
    case standby = "Standby"
    case waiting = "Waiting"
    case completed = "Completed"
    case error = "Error"
    
    var color: Color {
        switch self {
        case .active: return .green
        case .standby: return .yellow
        case .waiting: return .orange
        case .completed: return .blue
        case .error: return .red
        }
    }
}

// Travel Preferences for voice planning
struct TravelPreferences: Identifiable {
    let id = UUID()
    let destination: String
    let duration: Int // days
    let budget: BudgetRange
    let accommodationType: AccommodationType
    let activityPreferences: [ActivityPreference]
    let dietaryRestrictions: [String]
    let transportPreference: TransportPreference
    let companions: Int
}

enum BudgetRange: String, CaseIterable {
    case budget = "Budget (₹2,000-5,000/day)"
    case moderate = "Moderate (₹5,000-10,000/day)"
    case luxury = "Luxury (₹10,000+/day)"
    
    var displayName: String {
        return self.rawValue
    }
}

enum AccommodationType: String, CaseIterable {
    case budget = "Budget Hotel"
    case boutique = "Boutique Hotel"
    case luxury = "Luxury Resort"
    case homestay = "Homestay"
    case hostel = "Hostel"
    
    var icon: String {
        switch self {
        case .budget: return "bed.double"
        case .boutique: return "building.2"
        case .luxury: return "crown"
        case .homestay: return "house"
        case .hostel: return "person.3"
        }
    }
}

enum ActivityPreference: String, CaseIterable {
    case adventure = "Adventure"
    case relaxation = "Relaxation"
    case culture = "Culture"
    case food = "Food & Dining"
    case nightlife = "Nightlife"
    case nature = "Nature"
    case shopping = "Shopping"
    case photography = "Photography"
    
    var icon: String {
        switch self {
        case .adventure: return "figure.hiking"
        case .relaxation: return "leaf"
        case .culture: return "building.columns"
        case .food: return "fork.knife"
        case .nightlife: return "moon.stars"
        case .nature: return "tree"
        case .shopping: return "bag"
        case .photography: return "camera"
        }
    }
}

enum TransportPreference: String, CaseIterable {
    case flight = "Flight"
    case train = "Train"
    case bus = "Bus"
    case car = "Private Car"
    case any = "Any"
    
    var icon: String {
        switch self {
        case .flight: return "airplane"
        case .train: return "train.side.front.car"
        case .bus: return "bus"
        case .car: return "car"
        case .any: return "questionmark.circle"
        }
    }
}