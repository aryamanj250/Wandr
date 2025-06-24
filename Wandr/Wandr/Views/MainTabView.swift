//
//  MainTabView.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            TasksView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Tasks")
                }
                .tag(1)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "globe.americas.fill")
                    Text("Explore")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .tint(.white)
        .onAppear {
            setupTabBarAppearance()
        }
        .onChange(of: selectedTab) {
            // Add haptic feedback for tab switches
            let impact = UIImpactFeedbackGenerator(style: .soft)
            impact.impactOccurred()
        }
    }
    
    private func setupTabBarAppearance() {
        // Enhanced tab bar appearance with iOS 18 style
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Background with glass effect
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        
        // Add subtle shadow
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.3)
        
        // Normal state - iOS 18 style
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.7)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.7),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        // Selected state - iOS 18 enhanced
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        // Add subtle selection indicator background (iOS 18 feature)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.selected.badgeBackgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        // Apply to all tab bar states
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // iOS 18 enhancement: Subtle blur effect
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
}
