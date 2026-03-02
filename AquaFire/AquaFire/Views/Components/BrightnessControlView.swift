import SwiftUI

struct BrightnessControlView: View {
    @ObservedObject var fireplace: FireplaceState

    var body: some View {
        CardView {
            VStack(spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 14))
                    Text("Brightness")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }

                HStack(spacing: 20) {
                    // Decrease
                    StepperButton(systemName: "sun.min") {
                        fireplace.decreaseBrightness()
                    }

                    // Brightness bar
                    GeometryReader { geometry in
                        let totalWidth = geometry.size.width
                        let fillFraction = CGFloat(fireplace.brightness) / CGFloat(FireplaceState.maxLevel)

                        ZStack(alignment: .leading) {
                            // Track
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 10)

                            // Fill
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.orange.opacity(0.6), .orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: totalWidth * fillFraction, height: 10)
                                .animation(.easeInOut(duration: 0.2), value: fireplace.brightness)
                        }
                    }
                    .frame(height: 10)

                    // Increase
                    StepperButton(systemName: "sun.max") {
                        fireplace.increaseBrightness()
                    }
                }
                .frame(height: 40)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        BrightnessControlView(fireplace: FireplaceState())
            .padding()
    }
}
