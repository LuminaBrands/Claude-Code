import SwiftUI

/// Reusable card wrapper for consistent section styling
struct CardView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.black
        CardView {
            Text("Sample Card Content")
                .foregroundColor(.white)
        }
        .padding()
    }
}
