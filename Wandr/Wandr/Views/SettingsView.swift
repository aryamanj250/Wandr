//
//  SettingsView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var darkModeEnabled = true
    @State private var voiceEnabled = true
    @State private var budgetTracking = true
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                ButlerBackground()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Profile section
                        profileSection
                        
                        // Butler preferences
                        butlerPreferencesSection
                        
                        // App settings
                        appSettingsSection
                        
                        // Privacy & Security
                        privacySection
                        
                        // About section
                        aboutSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var profileSection: some View {
        VStack(spacing: 16) {
            // Profile header
            HStack {
                Text("Profile")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            // Profile info
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Travel Enthusiast")
                        .font(.custom("Futura", size: 18))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    
                    Text("Member since 2024")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("Edit")
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
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
    }
    
    private var butlerPreferencesSection: some View {
        VStack(spacing: 16) {
            // Section header
            HStack {
                Text("Alfred Preferences")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                SettingsToggleRow(
                    title: "Voice Assistance",
                    subtitle: "Enable voice commands and responses",
                    icon: "mic.fill",
                    iconColor: .blue,
                    isOn: $voiceEnabled
                )
                
                SettingsToggleRow(
                    title: "Smart Notifications",
                    subtitle: "Get timely reminders and suggestions",
                    icon: "bell.fill",
                    iconColor: .orange,
                    isOn: $notificationsEnabled
                )
                
                SettingsToggleRow(
                    title: "Budget Tracking",
                    subtitle: "Monitor and optimize your travel spending",
                    icon: "dollarsign.circle.fill",
                    iconColor: .green,
                    isOn: $budgetTracking
                )
                
                SettingsToggleRow(
                    title: "Location Services",
                    subtitle: "For personalized recommendations",
                    icon: "location.fill",
                    iconColor: .red,
                    isOn: $locationEnabled
                )
            }
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
    }
    
    private var appSettingsSection: some View {
        VStack(spacing: 16) {
            // Section header
            HStack {
                Text("App Settings")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                SettingsRow(
                    title: "Currency",
                    subtitle: "USD ($)",
                    icon: "dollarsign.circle",
                    iconColor: .green,
                    action: {}
                )
                
                SettingsRow(
                    title: "Language",
                    subtitle: "English",
                    icon: "globe",
                    iconColor: .blue,
                    action: {}
                )
                
                SettingsRow(
                    title: "Default Trip Duration",
                    subtitle: "3-5 days",
                    icon: "calendar",
                    iconColor: .purple,
                    action: {}
                )
                
                SettingsRow(
                    title: "Travel Style",
                    subtitle: "Balanced",
                    icon: "figure.walk",
                    iconColor: .orange,
                    action: {}
                )
            }
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
    }
    
    private var privacySection: some View {
        VStack(spacing: 16) {
            // Section header
            HStack {
                Text("Privacy & Security")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                SettingsRow(
                    title: "Privacy Policy",
                    subtitle: "How we protect your data",
                    icon: "shield.fill",
                    iconColor: .blue,
                    action: {}
                )
                
                SettingsRow(
                    title: "Terms of Service",
                    subtitle: "Our terms and conditions",
                    icon: "doc.text.fill",
                    iconColor: .gray,
                    action: {}
                )
                
                SettingsRow(
                    title: "Data Export",
                    subtitle: "Download your travel data",
                    icon: "square.and.arrow.up.fill",
                    iconColor: .green,
                    action: {}
                )
                
                SettingsRow(
                    title: "Delete Account",
                    subtitle: "Permanently delete your account",
                    icon: "trash.fill",
                    iconColor: .red,
                    action: {}
                )
            }
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
    }
    
    private var aboutSection: some View {
        VStack(spacing: 16) {
            // Section header
            HStack {
                Text("About")
                    .font(.custom("Futura", size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                SettingsRow(
                    title: "Version",
                    subtitle: "1.0.0 (2024.1)",
                    icon: "info.circle.fill",
                    iconColor: .blue,
                    action: {}
                )
                
                SettingsRow(
                    title: "Help & Support",
                    subtitle: "Get help with using Wandr",
                    icon: "questionmark.circle.fill",
                    iconColor: .purple,
                    action: {}
                )
                
                SettingsRow(
                    title: "Rate Wandr",
                    subtitle: "Share your experience",
                    icon: "star.fill",
                    iconColor: .yellow,
                    action: {}
                )
                
                SettingsRow(
                    title: "Share with Friends",
                    subtitle: "Spread the wanderlust",
                    icon: "heart.fill",
                    iconColor: .pink,
                    action: {}
                )
            }
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
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Futura", size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    
                    Text(subtitle)
                        .font(.custom("Futura", size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(.custom("Futura", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(.white.opacity(0.3))
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SettingsView()
}