//
//  AppleDesignSystem.swift
//  Wandr
//
//  Created by AI on 24/06/25.
//

import SwiftUI

// MARK: - Apple Design System
struct AppleDesign {
    
    // MARK: - Spacing System (Based on 8pt grid)
    struct Spacing {
        static let xs: CGFloat = 4      // 4pt
        static let sm: CGFloat = 8      // 8pt
        static let md: CGFloat = 16     // 16pt
        static let lg: CGFloat = 24     // 24pt
        static let xl: CGFloat = 32     // 32pt
        static let xxl: CGFloat = 48    // 48pt
        static let xxxl: CGFloat = 64   // 64pt
        
        // Semantic spacing
        static let cardPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 32
        static let elementSpacing: CGFloat = 12
        static let tightSpacing: CGFloat = 6
        static let screenPadding: CGFloat = 20
    }
    
    // MARK: - Corner Radius System
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 20
        static let xxlarge: CGFloat = 28
        
        // Semantic radius
        static let card: CGFloat = 16
        static let button: CGFloat = 12
        static let modal: CGFloat = 20
        static let icon: CGFloat = 8
    }
    
    // MARK: - Typography System (Futura Font Family)
    struct Typography {
        // Display fonts using Futura
        static let largeTitle = Font.custom("Futura", size: 28).bold()
        static let title1 = Font.custom("Futura", size: 24).bold()
        static let title2 = Font.custom("Futura", size: 22).weight(.semibold)
        static let title3 = Font.custom("Futura", size: 20).weight(.semibold)
        
        // Body fonts using Futura
        static let body = Font.custom("Futura", size: 17)
        static let bodyEmphasis = Font.custom("Futura", size: 17).weight(.medium)
        static let bodyLarge = Font.custom("Futura", size: 19)
        static let bodyBold = Font.custom("Futura", size: 17).weight(.semibold)
        
        // Detail fonts using Futura
        static let subheadline = Font.custom("Futura", size: 15).weight(.medium)
        static let footnote = Font.custom("Futura", size: 13)
        static let caption1 = Font.custom("Futura", size: 12).weight(.medium)
        static let caption2 = Font.custom("Futura", size: 11)
        
        // Custom app fonts using Futura
        static let appTitle = Font.custom("Futura", size: 28).bold()
        static let cardTitle = Font.custom("Futura", size: 20).weight(.semibold)
        static let cardSubtitle = Font.custom("Futura", size: 15)
        static let label = Font.custom("Futura", size: 11).weight(.medium)
        static let buttonText = Font.custom("Futura", size: 16).weight(.medium)
        
        // Enhanced typography features using Futura
        static let extraLargeTitle = Font.custom("Futura", size: 36).bold()
        static let callout = Font.custom("Futura", size: 16)
        static let headline = Font.custom("Futura", size: 17).weight(.semibold)
        
        // Navigation & UI specific using Futura
        static let navigationTitle = Font.custom("Futura", size: 22).bold()
        static let tabTitle = Font.custom("Futura", size: 10).weight(.medium)
        
        // Specialized content using Futura
        static let timelineTitle = Font.custom("Futura", size: 18).weight(.semibold)
        static let timelineSubtitle = Font.custom("Futura", size: 14)
        static let statusText = Font.custom("Futura", size: 12).weight(.medium)
        static let priceText = Font.custom("Futura", size: 16).bold()
    }
    
    // MARK: - Color System (Enhanced)
    struct Colors {
        // Primary colors
        static let background = Color.black
        static let surface = Color.white.opacity(0.06)
        static let surfaceElevated = Color.white.opacity(0.08)
        static let surfaceInteractive = Color.white.opacity(0.12)
        
        // Text colors with proper contrast
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.8)
        static let textTertiary = Color.white.opacity(0.6)
        static let textQuaternary = Color.white.opacity(0.4)
        
        // Interactive colors
        static let accent = Color.white
        static let accentSecondary = Color.white.opacity(0.8)
        static let destructive = Color.red
        static let warning = Color.orange
        static let success = Color.green
        
        // Status colors
        static let active = Color.green
        static let pending = Color.orange
        static let inactive = Color.gray
        static let info = Color.blue
        
        // Border colors
        static let border = Color.white.opacity(0.15)
        static let borderLight = Color.white.opacity(0.08)
        static let borderAccent = Color.white.opacity(0.3)
        
        // Shadow colors
        static let shadowLight = Color.black.opacity(0.1)
        static let shadowMedium = Color.black.opacity(0.2)
        static let shadowDark = Color.black.opacity(0.3)
    }
    
    // MARK: - Shadow System
    struct Shadows {
        static let small = (color: Colors.shadowLight, radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        static let medium = (color: Colors.shadowMedium, radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
        static let large = (color: Colors.shadowMedium, radius: CGFloat(16), x: CGFloat(0), y: CGFloat(8))
        static let floating = (color: Colors.shadowDark, radius: CGFloat(20), x: CGFloat(0), y: CGFloat(10))
    }
    
    // MARK: - Button Styles
    static func primaryButton(isPressed: Bool = false) -> some ShapeStyle {
        if isPressed {
            return AnyShapeStyle(Colors.surfaceInteractive)
        } else {
            return AnyShapeStyle(LinearGradient(
                colors: [Colors.surface, Colors.surfaceElevated],
                startPoint: .top,
                endPoint: .bottom
            ))
        }
    }
    
    static func secondaryButton(isPressed: Bool = false) -> some ShapeStyle {
        if isPressed {
            return AnyShapeStyle(Colors.surface)
        } else {
            return AnyShapeStyle(Colors.surfaceElevated)
        }
    }
}

// MARK: - Apple-style Card Component
struct AppleCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let cornerRadius: CGFloat
    let shadowStyle: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)?
    
    init(
        padding: CGFloat = AppleDesign.Spacing.cardPadding,
        cornerRadius: CGFloat = AppleDesign.CornerRadius.card,
        shadowStyle: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)? = AppleDesign.Shadows.medium,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowStyle = shadowStyle
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AppleDesign.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(AppleDesign.Colors.border, lineWidth: 0.5)
                    )
            )
            .modifier(ShadowModifier(shadowStyle: shadowStyle))
    }
}

// MARK: - Apple-style Button Component
struct AppleButton<Content: View>: View {
    let content: Content
    let action: () -> Void
    let style: ButtonStyleType
    let size: ButtonSize
    @State private var isPressed = false
    
    enum ButtonStyleType {
        case primary, secondary, accent, destructive
    }
    
    enum ButtonSize {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium: return EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
            case .large: return EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return AppleDesign.CornerRadius.small
            case .medium: return AppleDesign.CornerRadius.button
            case .large: return AppleDesign.CornerRadius.large
            }
        }
    }
    
    init(
        style: ButtonStyleType = .primary,
        size: ButtonSize = .medium,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.action = action
        self.style = style
        self.size = size
    }
    
    var body: some View {
        Button(action: action) {
            content
                .padding(size.padding)
                .background(backgroundStyle)
                .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .animation(AppleAnimations.buttonTap, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            isPressed = pressing
        }, perform: {})
    }
    
    @ViewBuilder
    private var backgroundStyle: some View {
        switch style {
        case .primary:
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(AppleDesign.primaryButton(isPressed: isPressed))
                .overlay(
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .stroke(AppleDesign.Colors.borderAccent, lineWidth: 0.5)
                )
        case .secondary:
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(AppleDesign.secondaryButton(isPressed: isPressed))
                .overlay(
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .stroke(AppleDesign.Colors.border, lineWidth: 0.5)
                )
        case .accent:
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(AppleDesign.Colors.accent)
        case .destructive:
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(AppleDesign.Colors.destructive.opacity(isPressed ? 0.8 : 1.0))
        }
    }
}

// MARK: - Status Indicator Component
struct StatusIndicator: View {
    let status: StatusType
    let text: String
    let showPulse: Bool
    
    enum StatusType {
        case active, pending, inactive, success, warning, error
        
        var color: Color {
            switch self {
            case .active: return AppleDesign.Colors.active
            case .pending: return AppleDesign.Colors.pending
            case .inactive: return AppleDesign.Colors.inactive
            case .success: return AppleDesign.Colors.success
            case .warning: return AppleDesign.Colors.warning
            case .error: return AppleDesign.Colors.destructive
            }
        }
    }
    
    init(status: StatusType, text: String, showPulse: Bool = false) {
        self.status = status
        self.text = text
        self.showPulse = showPulse
    }
    
    var body: some View {
        HStack(spacing: AppleDesign.Spacing.xs) {
            ZStack {
                Circle()
                    .fill(status.color)
                    .frame(width: 8, height: 8)
                
                if showPulse {
                    Circle()
                        .stroke(status.color.opacity(0.3), lineWidth: 2)
                        .frame(width: 12, height: 12)
                        .scaleEffect(1.5)
                        .opacity(0.8)
                        .animation(
                            Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: showPulse
                        )
                }
            }
            
            Text(text)
                .font(AppleDesign.Typography.label)
                .foregroundColor(status.color)
                .fontWeight(.medium)
                .tracking(0.5)
        }
    }
}

// MARK: - Helper Modifiers
struct ShadowModifier: ViewModifier {
    let shadowStyle: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)?
    
    func body(content: Content) -> some View {
        if let shadow = shadowStyle {
            content
                .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
        } else {
            content
        }
    }
}

// MARK: - Progressive Blur Background
struct ProgressiveBlurBackground: View {
    let intensity: Double
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    AppleDesign.Colors.background,
                    AppleDesign.Colors.background.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Subtle noise texture
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.02),
                            Color.clear,
                            Color.white.opacity(0.01)
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 300
                    )
                )
                .opacity(intensity)
        }
    }
}

// MARK: - Glass Effect Modifier
struct GlassEffect: ViewModifier {
    let intensity: Double
    let blur: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: AppleDesign.CornerRadius.card)
                    .fill(.ultraThinMaterial)
                    .opacity(intensity)
            )
            .background(
                RoundedRectangle(cornerRadius: AppleDesign.CornerRadius.card)
                    .fill(AppleDesign.Colors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppleDesign.CornerRadius.card)
                    .stroke(
                        LinearGradient(
                            colors: [
                                AppleDesign.Colors.border,
                                AppleDesign.Colors.borderLight
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
    }
}

extension View {
    func glassEffect(intensity: Double = 0.8, blur: CGFloat = 10) -> some View {
        self.modifier(GlassEffect(intensity: intensity, blur: blur))
    }
}
