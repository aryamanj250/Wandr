//
//  AnimatedPreferencesView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct AnimatedPreferencesView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentQuestion: PreferenceQuestion = .start
    @State private var selectedBudget: BudgetRange = .budget
    @State private var selectedAccommodation: AccommodationType = .budget
    @State private var selectedActivities: Set<ActivityPreference> = []
    @State private var selectedTransport: TransportPreference = .any
    @State private var selectedDietary: Set<String> = []
    @State private var customDietary = ""
    @State private var showSummary = false
    @State private var goaStartTime: GoaStartTime = .now
    @State private var goaBeerPreference: GoaBeerType = .beachShacks
    @State private var goaOffbeatFocus: Set<GoaOffbeatType> = []
    @State private var showAgentAnimation = false

    let voiceResult: VoiceInputResult
    let onComplete: (TravelPreferences) -> Void

    // Check if this is the Goa demo
    private var isGoaDemo: Bool {
        voiceResult.destination.contains("Goa") && voiceResult.destination.contains("Offbeat")
    }

    private var questionsToShow: [PreferenceQuestion] {
        if isGoaDemo {
            return [.start, .goaStartTime, .goaOffbeat, .goaBeer, .goaTransport]
        } else {
            return [.start, .budget, .accommodation, .activities, .transport, .dietary]
        }
    }

    var body: some View {
        ZStack {
            // Background
            ButlerBackground()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Progress indicator
                progressIndicator

                // Question content
                questionContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Navigation buttons
                navigationButtons
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
    }

    private var progressIndicator: some View {
        VStack(spacing: 12) {
            // Trip context
            VStack(spacing: 4) {
                Text("Planning Your Trip")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(voiceResult.destination)
                    .font(.custom("Futura", size: 16))
                    .foregroundStyle(.blue)

                HStack(spacing: 16) {
                    Label("\(voiceResult.duration) days", systemImage: "calendar")
                    Label("\(voiceResult.companions) people", systemImage: "person.3.fill")
                }
                .font(.custom("Futura", size: 12))
                .foregroundStyle(.white.opacity(0.7))
            }

            // Progress bar
            HStack(spacing: 8) {
                ForEach(0..<PreferenceQuestion.allCases.count, id: \.self) { index in
                    let isActive = index <= currentQuestion.rawValue

                    Circle()
                        .fill(isActive ? .blue : .white.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(isActive ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
                }
            }

            Text("Question \(currentQuestion.rawValue + 1) of \(PreferenceQuestion.allCases.count)")
                .font(.custom("Futura", size: 12))
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    @ViewBuilder
    private var questionContent: some View {
        if showSummary {
            summaryView
        } else {
            switch currentQuestion {
            case .start:
                startQuestion
            case .budget:
                budgetQuestion
            case .accommodation:
                accommodationQuestion
            case .activities:
                activitiesQuestion
            case .transport:
                transportQuestion
            case .dietary:
                dietaryQuestion
            }
        }
    }

    // MARK: - Question Views

    private var startQuestion: some View {
        QuestionContainer(
            title: "Let's plan your perfect trip!",
            subtitle: "I'll ask you a few quick questions to understand your preferences."
        ) {
            VStack(spacing: 16) {
                // Clean start without showing original input
            }
        }
    }

    private var budgetQuestion: some View {
        QuestionContainer(
            title: "What's your budget range?",
            subtitle: "This helps me find the best options for you"
        ) {
            VStack(spacing: 16) {
                ForEach(BudgetRange.allCases, id: \.self) { budget in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedBudget = budget
                        }
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(budget.rawValue.components(separatedBy: " (").first ?? budget.rawValue)
                                    .font(.custom("Futura", size: 16))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)

                                if budget.rawValue.contains("(") {
                                    Text("(\(budget.rawValue.components(separatedBy: " (").last?.replacingOccurrences(of: ")", with: "") ?? "")")
                                        .font(.custom("Futura", size: 14))
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                            }

                            Spacer()

                            if selectedBudget == budget {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.green)
                            } else {
                                Circle()
                                    .stroke(.white.opacity(0.3), lineWidth: 2)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(selectedBudget == budget ? .green.opacity(0.1) : .white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(selectedBudget == budget ? .green.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }

    private var accommodationQuestion: some View {
        QuestionContainer(
            title: "What's your accommodation style?",
            subtitle: "Choose what fits your vibe"
        ) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                ForEach(AccommodationType.allCases, id: \.self) { accommodation in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedAccommodation = accommodation
                        }
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: accommodation.icon)
                                .font(.system(size: 32))
                                .foregroundStyle(selectedAccommodation == accommodation ? .blue : .white.opacity(0.7))

                            Text(accommodation.rawValue)
                                .font(.custom("Futura", size: 14))
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(selectedAccommodation == accommodation ? .blue.opacity(0.1) : .white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(selectedAccommodation == accommodation ? .blue.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }

    private var activitiesQuestion: some View {
        QuestionContainer(
            title: "What experiences interest you?",
            subtitle: "Select all that sound fun (you can choose multiple)"
        ) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 12) {
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
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedActivities.contains(activity) ? .orange.opacity(0.1) : .white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedActivities.contains(activity) ? .orange.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }

    private var transportQuestion: some View {
        QuestionContainer(
            title: "How would you like to get there?",
            subtitle: "I'll find the best options for your chosen transport"
        ) {
            HStack(spacing: 12) {
                ForEach(TransportPreference.allCases, id: \.self) { transport in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTransport = transport
                        }
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: transport.icon)
                                .font(.system(size: 24))
                                .foregroundStyle(selectedTransport == transport ? .purple : .white.opacity(0.7))

                            Text(transport.rawValue)
                                .font(.custom("Futura", size: 11))
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTransport == transport ? .purple.opacity(0.1) : .white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedTransport == transport ? .purple.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }

    private var dietaryQuestion: some View {
        QuestionContainer(
            title: "Any dietary preferences?",
            subtitle: "This helps me recommend the best local spots"
        ) {
            VStack(spacing: 20) {
                // Common options
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 12) {
                    ForEach(["Vegetarian", "Vegan", "Gluten-free", "Halal"], id: \.self) { restriction in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedDietary.contains(restriction) {
                                    selectedDietary.remove(restriction)
                                } else {
                                    selectedDietary.insert(restriction)
                                }
                            }
                        }) {
                            Text(restriction)
                                .font(.custom("Futura", size: 14))
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedDietary.contains(restriction) ? .red.opacity(0.1) : .white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedDietary.contains(restriction) ? .red.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }

                // None option
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedDietary.removeAll()
                        customDietary = ""
                    }
                }) {
                    Text("No dietary restrictions")
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedDietary.isEmpty && customDietary.isEmpty ? .green.opacity(0.1) : .white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedDietary.isEmpty && customDietary.isEmpty ? .green.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                )
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }

    private var summaryView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Perfect! Here's your plan")
                    .font(.custom("Futura", size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Let me deploy AI agents to make this amazing")
                    .font(.custom("Futura", size: 16))
                    .foregroundStyle(.white.opacity(0.8))
            }

            ScrollView {
                VStack(spacing: 16) {
                    // Trip overview
                    summaryCard(title: "Trip Overview", icon: "location.fill", color: .blue) {
                        VStack(alignment: .leading, spacing: 8) {
                            summaryRow(label: "Destination", value: voiceResult.destination)
                            summaryRow(label: "Duration", value: "\(voiceResult.duration) days")
                            summaryRow(label: "Travelers", value: "\(voiceResult.companions) people")
                        }
                    }

                    // Budget & accommodation
                    summaryCard(title: "Budget & Stay", icon: "creditcard.fill", color: .green) {
                        VStack(alignment: .leading, spacing: 8) {
                            summaryRow(label: "Budget", value: selectedBudget.displayName)
                            summaryRow(label: "Accommodation", value: selectedAccommodation.rawValue)
                            summaryRow(label: "Transport", value: selectedTransport.rawValue)
                        }
                    }

                    // Activities
                    if !selectedActivities.isEmpty {
                        summaryCard(title: "Experiences", icon: "star.fill", color: .orange) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                                ForEach(Array(selectedActivities), id: \.self) { activity in
                                    Text(activity.rawValue)
                                        .font(.custom("Futura", size: 12))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(.orange.opacity(0.2))
                                        )
                                }
                            }
                        }
                    }

                    // Dietary
                    if !selectedDietary.isEmpty || !customDietary.isEmpty {
                        summaryCard(title: "Dietary", icon: "fork.knife", color: .red) {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(Array(selectedDietary), id: \.self) { restriction in
                                    Text("• \(restriction)")
                                        .font(.custom("Futura", size: 14))
                                        .foregroundStyle(.white.opacity(0.8))
                                }
                                if !customDietary.isEmpty {
                                    Text("• \(customDietary)")
                                        .font(.custom("Futura", size: 14))
                                        .foregroundStyle(.white.opacity(0.8))
                                }
                            }
                        }
                    }
                }
            }

            // Deploy button
            Button(action: {
                let preferences = createPreferences()
                onComplete(preferences)
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

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Helper Views

    private func summaryCard<Content: View>(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(color)

                Text(title)
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }

            content()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("Futura", size: 14))
                .foregroundStyle(.white.opacity(0.7))

            Spacer()

            Text(value)
                .font(.custom("Futura", size: 14))
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if currentQuestion != .start {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if showSummary {
                            showSummary = false
                        } else {
                            currentQuestion = PreferenceQuestion(rawValue: currentQuestion.rawValue - 1) ?? .start
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14))
                        Text("Back")
                            .font(.custom("Futura", size: 16))
                    }
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }

            Spacer()

            if !showSummary {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if currentQuestion == .dietary {
                            showSummary = true
                        } else {
                            currentQuestion = PreferenceQuestion(rawValue: currentQuestion.rawValue + 1) ?? .start
                        }
                    }
                }) {
                    HStack {
                        Text(currentQuestion == .dietary ? "Review" : "Next")
                            .font(.custom("Futura", size: 16))
                            .fontWeight(.medium)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                    }
                    .foregroundStyle(.black)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(!canProceed)
                .opacity(canProceed ? 1.0 : 0.6)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }

    private var canProceed: Bool {
        switch currentQuestion {
        case .start: return true
        case .budget: return true
        case .accommodation: return true
        case .activities: return !selectedActivities.isEmpty
        case .transport: return true
        case .dietary: return true
        }
    }

    private func createPreferences() -> TravelPreferences {
        var allDietary = Array(selectedDietary)
        if !customDietary.isEmpty {
            allDietary.append(customDietary)
        }

        return TravelPreferences(
            destination: voiceResult.destination,
            duration: voiceResult.duration,
            budget: selectedBudget,
            accommodationType: selectedAccommodation,
            activityPreferences: Array(selectedActivities),
            dietaryRestrictions: allDietary,
            transportPreference: selectedTransport,
            companions: voiceResult.companions
        )
    }
}

// MARK: - Supporting Views

struct QuestionContainer<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text(title)
                        .font(.custom("Futura", size: 22))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text(subtitle)
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                content
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
}

enum PreferenceQuestion: Int, CaseIterable {
    case start = 0
    case budget = 1
    case accommodation = 2
    case activities = 3
    case transport = 4
    case dietary = 5
}

#Preview {
    NavigationView {
        AnimatedPreferencesView(
            voiceResult: VoiceInputResult(
                destination: "Goa, India",
                duration: 4,
                companions: 4,
                originalInput: "me and my friend in goa with around 5k in our pocket and need to get back to the airport at 12 .. plan this trip which should include all the offbeat places.. also include beer"
            )
        ) { preferences in
            print("Preferences completed: \(preferences)")
        }
    }
}
