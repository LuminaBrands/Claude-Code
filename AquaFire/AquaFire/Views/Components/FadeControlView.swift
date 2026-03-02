import SwiftUI

struct FadeControlView: View {
    @ObservedObject var fireplace: FireplaceState

    var body: some View {
        CardView {
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    fireplace.toggleFade()
                }
            } label: {
                HStack(spacing: 14) {
                    // Animated icon
                    ZStack {
                        Circle()
                            .fill(
                                fireplace.isFadeActive
                                    ? LinearGradient(
                                        colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    : LinearGradient(
                                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                            )
                            .frame(width: 44, height: 44)

                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 20))
                            .foregroundColor(fireplace.isFadeActive ? .white : .gray.opacity(0.5))
                            .symbolEffect(.pulse, isActive: fireplace.isFadeActive)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("FADE")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(fireplace.isFadeActive ? .white : .white.opacity(0.5))

                        Text("RGB Play of Lights")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.4))
                    }

                    Spacer()

                    // Status badge
                    Text(fireplace.isFadeActive ? "ACTIVE" : "OFF")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(fireplace.isFadeActive ? .white : .gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(
                                    fireplace.isFadeActive
                                        ? LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
                                        : LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                                )
                        )
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ZStack {
        Color.black
        VStack {
            FadeControlView(fireplace: {
                let fp = FireplaceState()
                fp.isFadeActive = true
                return fp
            }())
            FadeControlView(fireplace: FireplaceState())
        }
        .padding()
    }
}
