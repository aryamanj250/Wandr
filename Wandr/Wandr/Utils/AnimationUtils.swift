//
//  AnimationUtils.swift
//  Wandr
//
//  Created by AI on 23/06/25.
//

import SwiftUI

// Animation constants for consistent animations across the app
enum AppAnimation {
    // Timing curves
    static let spring = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.6)
    static let gentle = Animation.spring(response: 0.7, dampingFraction: 0.9)
    
    // Durations
    static let fast = Animation.easeOut(duration: 0.3)
    static let standard = Animation.easeOut(duration: 0.5)
    static let slow = Animation.easeOut(duration: 0.8)
    
    // Specialized animations
    static func staggered(index: Int, baseDelay: Double = 0.1) -> Animation {
        return Animation.spring(response: 0.5, dampingFraction: 0.8)
            .delay(Double(index) * baseDelay)
    }
    
    static func reveal(delay: Double = 0.0) -> Animation {
        return Animation.easeOut(duration: 0.6).delay(delay)
    }
}

// View modifiers for common animation patterns
struct FadeInModifier: ViewModifier {
    let delay: Double
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.6).delay(delay)) {
                    opacity = 1
                }
            }
    }
}

struct SlideInModifier: ViewModifier {
    let delay: Double
    let edge: Edge
    @State private var offset: CGFloat = 30
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .offset(x: edge == .leading || edge == .trailing ? (edge == .leading ? offset : -offset) : 0,
                    y: edge == .top || edge == .bottom ? (edge == .top ? offset : -offset) : 0)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay)) {
                    offset = 0
                    opacity = 1
                }
            }
    }
}

struct ScaleInModifier: ViewModifier {
    let delay: Double
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay)) {
                    scale = 1
                    opacity = 1
                }
            }
    }
}

// View extensions for easier use
extension View {
    func fadeIn(delay: Double = 0) -> some View {
        self.modifier(FadeInModifier(delay: delay))
    }
    
    func slideIn(from edge: Edge, delay: Double = 0) -> some View {
        self.modifier(SlideInModifier(delay: delay, edge: edge))
    }
    
    func scaleIn(delay: Double = 0) -> some View {
        self.modifier(ScaleInModifier(delay: delay))
    }
}
