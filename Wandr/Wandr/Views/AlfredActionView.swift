//
//  AlfredActionView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct AlfredActionView: View {
    let action: AlfredAction
    @Binding var isShowing: Bool
    @State private var currentProgress: Double = 0.0
    @State private var showResult = false
    @State private var showHotelOptions = false
    
    var body: some View {
        ZStack {
            // Blur background
            Color.black.opacity(0.6)
                .background(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    if showResult {
                        withAnimation(.easeOut(duration: 0.3)) {
                            isShowing = false
                        }
                    }
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Alfred action content
                VStack(spacing: 24) {
                    // Header
                    actionHeader
                    
                    if !showResult {
                        // Progress section
                        progressSection
                        
                        // Steps section
                        stepsSection
                    } else {
                        // Results section
                        resultsSection
                    }
                    
                    // Action buttons
                    actionButtons
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.black.opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .onAppear {
            startProgress()
        }
        .sheet(isPresented: $showHotelOptions) {
            HotelSelectionView()
        }
    }
    
    private var actionHeader: some View {
        VStack(spacing: 12) {
            // Alfred icon
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "person.fill.badge.plus")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)
            }
            
            Text(action.title)
                .font(.custom("Futura", size: 22))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            Text(action.description)
                .font(.custom("Futura", size: 16))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: 16) {
            // Progress circle
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.1), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: currentProgress)
                    .stroke(.blue, lineWidth: 8)
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: currentProgress)
                
                Text("\(Int(currentProgress * 100))%")
                    .font(.custom("Futura", size: 18))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            if let estimatedTime = action.estimatedTime {
                Text("Estimated time: \(estimatedTime)")
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
    
    private var stepsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Alfred is working...")
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(action.steps) { step in
                    ActionStepRow(step: step)
                }
            }
        }
    }
    
    private var resultsSection: some View {
        VStack(spacing: 20) {
            // Success indicator
            ZStack {
                Circle()
                    .fill(.green.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.green)
            }
            
            Text("Trip Plan Ready!")
                .font(.custom("Futura", size: 20))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("I found great options for your Goa trip. Let me show you the recommendations.")
                .font(.custom("Futura", size: 16))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            // Quick results summary
            VStack(spacing: 12) {
                ResultRow(icon: "airplane.fill", title: "Flights", detail: "₹8,500 per person", color: .blue)
                ResultRow(icon: "building.2.fill", title: "Hotels", detail: "3 options found", color: .green)
                ResultRow(icon: "car.fill", title: "Transport", detail: "Airport transfers included", color: .orange)
                ResultRow(icon: "star.fill", title: "Activities", detail: "Beach & water sports", color: .yellow)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if showResult {
                Button(action: {
                    showHotelOptions = true
                }) {
                    HStack {
                        Text("View Hotel Options")
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
                    )
                }
                .buttonStyle(ScaleButtonStyle())
                
                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isShowing = false
                    }
                }) {
                    Text("View Complete Itinerary")
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            } else {
                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isShowing = false
                    }
                }) {
                    Text("Cancel")
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
    
    private func startProgress() {
        // Simulate progressive completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                currentProgress = 0.6
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 1.0)) {
                currentProgress = 0.85
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                currentProgress = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    showResult = true
                }
            }
        }
    }
}

struct ActionStepRow: View {
    let step: ActionStep
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 24, height: 24)
                
                if step.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                } else if step.isActive {
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                } else {
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                        .frame(width: 12, height: 12)
                }
            }
            
            // Step info
            VStack(alignment: .leading, spacing: 2) {
                Text(step.title)
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Text(step.description)
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            if let duration = step.duration {
                Text(duration)
                    .font(.custom("Futura", size: 11))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
    
    private var backgroundColor: Color {
        if step.isCompleted {
            return .green
        } else if step.isActive {
            return .blue
        } else {
            return .white.opacity(0.1)
        }
    }
}

struct ResultRow: View {
    let icon: String
    let title: String
    let detail: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Futura", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Text(detail)
                    .font(.custom("Futura", size: 12))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AlfredActionView(
        action: AlfredAction(
            title: "Planning Your Goa Trip",
            description: "Setting up a 4-day trip to Goa for 4 people",
            status: .inProgress,
            progress: 0.3,
            estimatedTime: "2-3 minutes",
            steps: [
                ActionStep(id: UUID(), title: "Searching flights", description: "Finding best flight options", isCompleted: true, isActive: false, duration: "30s"),
                ActionStep(id: UUID(), title: "Comparing hotels", description: "Analyzing 50+ hotels", isCompleted: false, isActive: true, duration: "45s")
            ],
            result: nil
        ),
        isShowing: .constant(true)
    )
}