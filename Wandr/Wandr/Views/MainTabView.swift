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
            HomeView()
                .tabItem {
                    Image(systemName: "person.fill.badge.plus")
                    Text("Alfred")
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
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            
            // Normal state
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.6)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white.withAlphaComponent(0.6),
                .font: UIFont(name: "Futura-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10)
            ]
            
            // Selected state
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont(name: "Futura-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
}