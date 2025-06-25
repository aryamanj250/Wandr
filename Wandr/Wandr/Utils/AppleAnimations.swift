//
//  AppleAnimations.swift
//  Wandr
//
//  Created by AI on 24/06/25.
//

import SwiftUI

// MARK: - Apple-like Animation System (iOS 18 Enhanced)
struct AppleAnimations {
    
    // MARK: - Core Animation Curves (iOS 18 Refined)
    static let easeIn = Animation.timingCurve(0.42, 0, 1, 1, duration: 0.35)
    static let easeOut = Animation.timingCurve(0, 0, 0.58, 1, duration: 0.35)
    static let easeInOut = Animation.timingCurve(0.42, 0, 0.58, 1, duration: 0.35)
    
    // iOS 18 enhanced spring animations with better physics
    static let spring = Animation.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.25)
    static let gentleSpring = Animation.interactiveSpring(response: 0.7, dampingFraction: 0.9, blendDuration: 0.25)
    static let bouncySpring = Animation.interactiveSpring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.25)
    
    // MARK: - iOS 18 Specialized Animations
    static let modalPresentation = Animation.interactiveSpring(response: 0.5, dampingFraction: 0.85, blendDuration: 0.25)
    static let buttonTap = Animation.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.1)
    static let listItemAppear = Animation.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.2)
    static let fadeTransition = Animation.easeOut(duration: 0.25)
    static let quickFade = Animation.easeOut(duration: 0.15)
    static let smoothTransition = Animation.easeInOut(duration: 0.4)
    
    // iOS 18 new animation types
    static let heroTransition = Animation.interactiveSpring(response: 0.6, dampingFraction: 0.85, blendDuration: 0.3)
    static let contextualMenu = Animation.interactiveSpring(response: 0.4, dampingFraction: 0.9, blendDuration: 0.2)
    static let notification = Animation.interactiveSpring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.25)
    
    // MARK: - Staggered Animations
    static func staggered(index: Int, total: Int, baseAnimation: Animation = spring) -> Animation {
        let delay = Double(index) * (0.05 + (0.02 * Double(total - index) / Double(total)))
        return baseAnimation.delay(delay)
    }
    
    // MARK: - Physics-based Animations
    static func elasticScale(intensity: Double = 1.0) -> Animation {
        Animation.interpolatingSpring(
            stiffness: 300 * intensity,
            damping: 20 + (10 * intensity)
        )
    }
    
    static func rubberBand() -> Animation {
        Animation.interpolatingSpring(stiffness: 600, damping: 15)
    }
}

// MARK: - Apple-like View Modifiers
struct AppleScaleEffect: ViewModifier {
    let isPressed: Bool
    let scale: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(AppleAnimations.buttonTap, value: isPressed)
    }
}

struct AppleFadeIn: ViewModifier {
    let delay: Double
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(AppleAnimations.fadeTransition.delay(delay)) {
                    opacity = 1
                }
            }
    }
}

struct AppleSlideIn: ViewModifier {
    let edge: Edge
    let delay: Double
    let distance: CGFloat
    @State private var offset: CGFloat
    @State private var opacity: Double = 0
    
    init(edge: Edge, delay: Double = 0, distance: CGFloat = 30) {
        self.edge = edge
        self.delay = delay
        self.distance = distance
        self._offset = State(initialValue: distance)
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .offset(
                x: (edge == .leading) ? -offset : (edge == .trailing) ? offset : 0,
                y: (edge == .top) ? -offset : (edge == .bottom) ? offset : 0
            )
            .onAppear {
                withAnimation(AppleAnimations.spring.delay(delay)) {
                    offset = 0
                    opacity = 1
                }
            }
    }
}

struct AppleScaleIn: ViewModifier {
    let delay: Double
    let initialScale: CGFloat
    @State private var scale: CGFloat
    @State private var opacity: Double = 0
    
    init(delay: Double = 0, initialScale: CGFloat = 0.8) {
        self.delay = delay
        self.initialScale = initialScale
        self._scale = State(initialValue: initialScale)
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(AppleAnimations.spring.delay(delay)) {
                    scale = 1.0
                    opacity = 1
                }
            }
    }
}

struct AppleBlur: ViewModifier {
    let isBlurred: Bool
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isBlurred ? radius : 0)
            .animation(AppleAnimations.easeInOut, value: isBlurred)
    }
}

// MARK: - Interactive Animation Modifiers
struct AppleButtonPress: ViewModifier {
    @State private var isPressed = false
    let action: () -> Void
    let hapticFeedback: Bool
    
    init(action: @escaping () -> Void, hapticFeedback: Bool = true) {
        self.action = action
        self.hapticFeedback = hapticFeedback
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(AppleAnimations.buttonTap, value: isPressed)
            .onTapGesture {
                if hapticFeedback {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
                action()
            }
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                isPressed = pressing
            }, perform: {})
    }
}

struct AppleCardPress: ViewModifier {
    @State private var isPressed = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(AppleAnimations.gentleSpring, value: isPressed)
            .onTapGesture {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                action()
            }
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                isPressed = pressing
            }, perform: {})
    }
}

// MARK: - Floating Action Button Animation
struct FloatingActionButton: ViewModifier {
    @State private var isPressed = false
    @State private var scale: CGFloat = 1.0
    @State private var shadowRadius: CGFloat = 10
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .shadow(color: .black.opacity(0.15), radius: shadowRadius, x: 0, y: shadowRadius/2)
            .animation(AppleAnimations.gentleSpring, value: scale)
            .animation(AppleAnimations.gentleSpring, value: shadowRadius)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                if pressing {
                    scale = 0.95
                    shadowRadius = 5
                } else {
                    scale = 1.0
                    shadowRadius = 10
                }
            }, perform: {})
    }
}


// MARK: - Loading and Progress Animations
struct PulsingDot: View {
    let delay: Double
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.6
    
    var body: some View {
        Circle()
            .fill(.white.opacity(0.8))
            .frame(width: 8, height: 8)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    scale = 1.2
                    opacity = 1.0
                }
            }
    }
}

struct ProgressWave: View {
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        Wave(offset: waveOffset, amplitude: 5, frequency: 1.5)
            .stroke(.white.opacity(0.3), lineWidth: 2)
            .onAppear {
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    waveOffset = 2 * .pi
                }
            }
    }
}

struct Wave: Shape {
    let offset: CGFloat
    let amplitude: CGFloat
    let frequency: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midHeight = rect.height / 2
        let wavelength = rect.width / frequency
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let angle = (x / wavelength) * 2 * .pi + offset
            let y = midHeight + sin(angle) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}

// MARK: - View Extensions
extension View {
    func appleScaleEffect(isPressed: Bool, scale: CGFloat = 0.96) -> some View {
        self.modifier(AppleScaleEffect(isPressed: isPressed, scale: scale))
    }
    
    func appleFadeIn(delay: Double = 0) -> some View {
        self.modifier(AppleFadeIn(delay: delay))
    }
    
    func appleSlideIn(from edge: Edge, delay: Double = 0, distance: CGFloat = 30) -> some View {
        self.modifier(AppleSlideIn(edge: edge, delay: delay, distance: distance))
    }
    
    func appleScaleIn(delay: Double = 0, initialScale: CGFloat = 0.8) -> some View {
        self.modifier(AppleScaleIn(delay: delay, initialScale: initialScale))
    }
    
    func appleBlur(isBlurred: Bool, radius: CGFloat = 10) -> some View {
        self.modifier(AppleBlur(isBlurred: isBlurred, radius: radius))
    }
    
    func appleButtonPress(action: @escaping () -> Void, hapticFeedback: Bool = true) -> some View {
        self.modifier(AppleButtonPress(action: action, hapticFeedback: hapticFeedback))
    }
    
    func appleCardPress(action: @escaping () -> Void) -> some View {
        self.modifier(AppleCardPress(action: action))
    }
    
    func floatingActionButton() -> some View {
        self.modifier(FloatingActionButton())
    }
}
