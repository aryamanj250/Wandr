//
//  TravelPreferencesView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct TravelPreferencesView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedBudget: BudgetRange = .moderate
    @State private var selectedAccommodation: AccommodationType = .boutique
    @State private var selectedActivities: Set<ActivityPreference> = []
    @State private var selectedTransport: TransportPreference = .any
    @State private var dietaryRestrictions: [String] = []
    @State private var customDietaryText = ""
    @State private var showAgentDeployment = false
    
    let destination: String
    let duration: Int
    let companions: Int
    let onComplete: (TravelPreferences) -> Void
    
    var body: some View {
        ZStack {
            // Background
            ButlerBackground()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Budget Selection
                    budgetSection
                    
                    // Accommodation Type
                    accommodationSection
                    
                    // Activity Preferences
                    activitySection
                    
                    // Transport Preference
                    transportSection
                    
                    // Dietary Restrictions
                    dietarySection
                    
                    // Deploy Agents Button
                    deployAgentsButton
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
        }
        .sheet(isPresented: $showAgentDeployment) {
            AgentDeploymentView(
                preferences: createPreferences(),
                onComplete: { trip in
                    showAgentDeployment = false
                    onComplete(createPreferences())
                }
            )
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Plan Your Trip")
                .font(.custom("Futura", size: 28))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Destination: \(destination)")
                .font(.custom("Futura", size: 18))
                .foregroundStyle(.blue)
            
            HStack(spacing: 20) {
                Label("\(duration) days", systemImage: "calendar")
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                
                Label("\(companions) people", systemImage: "person.3.fill")
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(.top, 20)
    }
    
    private var budgetSection: some View {
        PreferenceSection(title: "Budget Range", icon: "creditcard.fill") {
            VStack(spacing: 12) {
                ForEach(BudgetRange.allCases, id: \.self) { budget in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedBudget = budget
                        }
                    }) {
                        HStack {
                            Text(budget.displayName)
                                .font(.custom("Futura", size: 16))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            if selectedBudget == budget {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else {
                                Circle()
                                    .stroke(.white.opacity(0.3), lineWidth: 2)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedBudget == budget ? .green.opacity(0.1) : .white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedBudget == budget ? .green.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
    
    private var accommodationSection: some View {
        PreferenceSection(title: "Accommodation Type", icon: "building.2.fill") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(AccommodationType.allCases, id: \.self) { accommodation in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedAccommodation = accommodation
                        }
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: accommodation.icon)
                                .font(.system(size: 24))
                                .foregroundStyle(selectedAccommodation == accommodation ? .blue : .white.opacity(0.7))
                            
                            Text(accommodation.rawValue)
                                .font(.custom("Futura", size: 14))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedAccommodation == accommodation ? .blue.opacity(0.1) : .white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedAccommodation == accommodation ? .blue.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
    
    private var activitySection: some View {
        PreferenceSection(title: "Activities", icon: "star.fill") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                ForEach(ActivityPreference.allCases, id: \.self) { activity in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if selectedActivities.contains(activity) {
                                selectedActivities.remove(activity)
                            } else {
                                selectedActivities.insert(activity)
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: activity.icon)
                                .font(.system(size: 16))
                                .foregroundStyle(selectedActivities.contains(activity) ? .orange : .white.opacity(0.7))
                            
                            Text(activity.rawValue)
                                .font(.custom("Futura", size: 13))
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedActivities.contains(activity) ? .orange.opacity(0.1) : .white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedActivities.contains(activity) ? .orange.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
    
    private var transportSection: some View {
        PreferenceSection(title: "Transport Preference", icon: "car.fill") {
            HStack(spacing: 12) {
                ForEach(TransportPreference.allCases, id: \.self) { transport in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTransport = transport
                        }
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: transport.icon)
                                .font(.system(size: 20))
                                .foregroundStyle(selectedTransport == transport ? .purple : .white.opacity(0.7))
                            
                            Text(transport.rawValue)
                                .font(.custom("Futura", size: 11))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedTransport == transport ? .purple.opacity(0.1) : .white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedTransport == transport ? .purple.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
    
    private var dietarySection: some View {
        PreferenceSection(title: "Dietary Restrictions", icon: "fork.knife") {
            VStack(spacing: 12) {
                // Common dietary restrictions
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                    ForEach(["Vegetarian", "Vegan", "Gluten-free", "Halal"], id: \.self) { restriction in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if dietaryRestrictions.contains(restriction) {
                                    dietaryRestrictions.removeAll { $0 == restriction }
                                } else {
                                    dietaryRestrictions.append(restriction)
                                }
                            }
                        }) {
                            Text(restriction)
                                .font(.custom("Futura", size: 13))
                                .foregroundStyle(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(dietaryRestrictions.contains(restriction) ? .red.opacity(0.1) : .white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(dietaryRestrictions.contains(restriction) ? .red.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                
                // Custom dietary restriction input
                TextField("Other dietary restrictions...", text: $customDietaryText)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .onSubmit {
                        if !customDietaryText.isEmpty && !dietaryRestrictions.contains(customDietaryText) {
                            dietaryRestrictions.append(customDietaryText)
                            customDietaryText = ""
                        }
                    }
            }
        }
    }
    
    private var deployAgentsButton: some View {
        Button(action: {
            showAgentDeployment = true
        }) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 18))
                
                Text("Deploy AI Agents")
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 14))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: 5)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
    }
    
    private var isFormValid: Bool {
        !selectedActivities.isEmpty
    }
    
    private func createPreferences() -> TravelPreferences {
        var allDietaryRestrictions = dietaryRestrictions
        if !customDietaryText.isEmpty {
            allDietaryRestrictions.append(customDietaryText)
        }
        
        return TravelPreferences(
            destination: destination,
            duration: duration,
            budget: selectedBudget,
            accommodationType: selectedAccommodation,
            activityPreferences: Array(selectedActivities),
            dietaryRestrictions: allDietaryRestrictions,
            transportPreference: selectedTransport,
            companions: companions
        )
    }
}

struct PreferenceSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.8))
                
                Text(title)
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            
            content
        }
    }
}

#Preview {
    NavigationView {
        TravelPreferencesView(
            destination: "Goa, India",
            duration: 4,
            companions: 4
        ) { preferences in
            print("Preferences selected: \(preferences)")
        }
    }
}