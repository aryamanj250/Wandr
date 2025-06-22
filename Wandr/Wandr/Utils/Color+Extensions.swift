//
//  Color+Extensions.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

extension Color {
    // App theme colors
    static let wandrBackground = Color.black
    static let wandrForeground = Color.white
    static let wandrAccent = Color.white
    
    // Text colors
    static let wandrTextPrimary = Color.white
    static let wandrTextSecondary = Color.white.opacity(0.7)
    static let wandrTextTertiary = Color.white.opacity(0.5)
    
    // UI element colors
    static let wandrCardBackground = Color.white.opacity(0.05)
    static let wandrCardBorder = Color.white.opacity(0.1)
    static let wandrButtonBackground = Color.white
    static let wandrButtonText = Color.black
    
    // Timeline element colors
    static let wandrTimelineDot = Color.white
    static let wandrTimelineLine = Color.white.opacity(0.2)
    
    // Badge colors
    static let wandrBadgeBackground = Color.white.opacity(0.1)
    static let wandrBadgeText = Color.white.opacity(0.8)
    
    // Create a dynamic color that darkens/lightens the original color
    func adjusted(by percentage: CGFloat) -> Color {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return Color(
            UIColor(
                red: min(max(red + percentage/100, 0.0), 1.0),
                green: min(max(green + percentage/100, 0.0), 1.0),
                blue: min(max(blue + percentage/100, 0.0), 1.0),
                alpha: alpha
            )
        )
    }
} 