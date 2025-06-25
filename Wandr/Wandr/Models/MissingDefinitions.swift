import SwiftUI

// Placeholder for VoiceInputResult based on usage in AnimatedPreferencesView
struct VoiceInputResult {
    var destination: String
    var duration: Int
    var companions: Int
    var originalInput: String? // Making it optional to avoid breaking other initializations
}

// Placeholder for ButlerBackground View
struct ButlerBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.8), Color.gray.opacity(0.6)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
