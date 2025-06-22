//
//  WandrApp.swift
//  Wandr
//
//  Created by aryaman jaiswal on 22/06/25.
//

import SwiftUI

@main
struct WandrApp: App {
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .opacity(showLaunchScreen ? 0 : 1)
                
                if showLaunchScreen {
                    LaunchScreen {
                        withAnimation {
                            showLaunchScreen = false
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
