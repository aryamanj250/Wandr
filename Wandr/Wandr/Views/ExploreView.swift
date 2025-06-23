//
//  ExploreView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var selectedCategory: ExploreCategory = .destinations
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                ButlerBackground()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Search bar
                    searchBar
                    
                    // Category tabs
                    categoryTabs
                    
                    // Content
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            switch selectedCategory {
                            case .destinations:
                                destinationsContent
                            case .experiences:
                                experiencesContent
                            case .inspiration:
                                inspirationContent
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.6))
            
            TextField("Search destinations, experiences...", text: $searchText)
                .font(.custom("Futura", size: 16))
                .foregroundStyle(.white)
                .tint(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoryTabs: some View {
        HStack(spacing: 0) {
            ForEach(ExploreCategory.allCases, id: \.self) { category in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedCategory = category
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: category.icon)
                            .font(.system(size: 16))
                        
                        Text(category.title)
                            .font(.custom("Futura", size: 12))
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(selectedCategory == category ? .white : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        selectedCategory == category ?
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            ) : nil
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            Rectangle()
                .fill(.black.opacity(0.3))
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundStyle(.white.opacity(0.1)),
                    alignment: .bottom
                )
        )
    }
    
    private var destinationsContent: some View {
        VStack(spacing: 20) {
            ForEach(sampleDestinations) { destination in
                DestinationCard(destination: destination)
            }
        }
    }
    
    private var experiencesContent: some View {
        VStack(spacing: 20) {
            ForEach(sampleExperiences) { experience in
                ExperienceCard(experience: experience)
            }
        }
    }
    
    private var inspirationContent: some View {
        VStack(spacing: 20) {
            ForEach(sampleInspirations) { inspiration in
                InspirationCard(inspiration: inspiration)
            }
        }
    }
    
    private var sampleDestinations: [ExploreDestination] {
        [
            ExploreDestination(
                name: "Tokyo, Japan",
                description: "Bustling metropolis with ancient traditions",
                imageUrl: nil,
                rating: 4.8,
                priceRange: "$$$",
                tags: ["Culture", "Food", "Technology"]
            ),
            ExploreDestination(
                name: "Paris, France",
                description: "City of light and romance",
                imageUrl: nil,
                rating: 4.7,
                priceRange: "$$$",
                tags: ["Art", "History", "Cuisine"]
            ),
            ExploreDestination(
                name: "Bali, Indonesia",
                description: "Tropical paradise with rich culture",
                imageUrl: nil,
                rating: 4.6,
                priceRange: "$$",
                tags: ["Beach", "Spirituality", "Nature"]
            )
        ]
    }
    
    private var sampleExperiences: [Experience] {
        [
            Experience(
                title: "Sushi Making Class",
                location: "Tokyo",
                duration: "3 hours",
                price: "$120",
                rating: 4.9,
                description: "Learn authentic sushi making from a master chef"
            ),
            Experience(
                title: "Seine River Cruise",
                location: "Paris",
                duration: "2 hours",
                price: "$45",
                rating: 4.5,
                description: "Romantic evening cruise with dinner"
            ),
            Experience(
                title: "Sunrise Volcano Hike",
                location: "Bali",
                duration: "6 hours",
                price: "$80",
                rating: 4.8,
                description: "Watch the sunrise from Mount Batur summit"
            )
        ]
    }
    
    private var sampleInspirations: [Inspiration] {
        [
            Inspiration(
                title: "Solo Travel Tips",
                subtitle: "Make the most of traveling alone",
                content: "Discover the freedom and self-discovery that comes with solo adventures.",
                imageUrl: nil,
                readTime: "5 min read"
            ),
            Inspiration(
                title: "Budget Travel Hacks",
                subtitle: "Travel more for less",
                content: "Expert tips to stretch your travel budget without compromising on experiences.",
                imageUrl: nil,
                readTime: "8 min read"
            ),
            Inspiration(
                title: "Sustainable Tourism",
                subtitle: "Travel responsibly",
                content: "How to minimize your environmental impact while exploring the world.",
                imageUrl: nil,
                readTime: "6 min read"
            )
        ]
    }
}

enum ExploreCategory: String, CaseIterable {
    case destinations = "Destinations"
    case experiences = "Experiences"
    case inspiration = "Inspiration"
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .destinations: return "globe.americas.fill"
        case .experiences: return "star.fill"
        case .inspiration: return "lightbulb.fill"
        }
    }
}

// Supporting Models
struct ExploreDestination: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageUrl: String?
    let rating: Double
    let priceRange: String
    let tags: [String]
}

struct Experience: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let duration: String
    let price: String
    let rating: Double
    let description: String
}

struct Inspiration: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let content: String
    let imageUrl: String?
    let readTime: String
}

// Supporting Card Views
struct DestinationCard: View {
    let destination: ExploreDestination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(destination.name)
                        .font(.custom("Futura", size: 18))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text(destination.description)
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", destination.rating))
                            .font(.custom("Futura", size: 12))
                            .foregroundStyle(.white)
                    }
                    
                    Text(destination.priceRange)
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            
            // Tags
            HStack {
                ForEach(destination.tags.prefix(3), id: \.self) { tag in
                    Text(tag)
                        .font(.custom("Futura", size: 10))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.1))
                        )
                }
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct ExperienceCard: View {
    let experience: Experience
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.blue)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(experience.title)
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text(experience.price)
                        .font(.custom("Futura", size: 14))
                        .fontWeight(.medium)
                        .foregroundStyle(.blue)
                }
                
                Text(experience.description)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(2)
                
                HStack {
                    Label(experience.location, systemImage: "location.fill")
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Label(experience.duration, systemImage: "clock.fill")
                        .font(.custom("Futura", size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct InspirationCard: View {
    let inspiration: Inspiration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.yellow)
                
                Text(inspiration.readTime)
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.6))
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(inspiration.title)
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text(inspiration.subtitle)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.8))
                
                Text(inspiration.content)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(3)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ExploreView()
}