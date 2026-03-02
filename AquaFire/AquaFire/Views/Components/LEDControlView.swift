import SwiftUI

struct LEDControlView: View {
    @ObservedObject var fireplace: FireplaceState

    var body: some View {
        CardView {
            VStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb.led.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 14))
                    Text("LED Controls")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }

                HStack(spacing: 16) {
                    // Orange LED Toggle
                    ledToggle(
                        label: "Orange LED",
                        icon: "flame.fill",
                        isOn: fireplace.isOrangeLEDOn,
                        activeColor: .orange
                    ) {
                        withAnimation { fireplace.toggleOrangeLED() }
                    }

                    // RGB LED Toggle
                    ledToggle(
                        label: "RGB LED",
                        icon: "sparkles",
                        isOn: fireplace.isRGBLEDOn,
                        activeColor: fireplace.currentColor
                    ) {
                        withAnimation { fireplace.toggleRGBLED() }
                    }
                }
            }
        }
    }

    private func ledToggle(
        label: String,
        icon: String,
        isOn: Bool,
        activeColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isOn ? activeColor.opacity(0.2) : Color.white.opacity(0.05))
                        .frame(height: 64)

                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(isOn ? activeColor : .gray.opacity(0.5))
                        .shadow(color: isOn ? activeColor.opacity(0.6) : .clear, radius: 8)
                }

                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isOn ? .white : .white.opacity(0.4))

                Text(isOn ? "ON" : "OFF")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(isOn ? activeColor : .gray.opacity(0.5))
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.black
        LEDControlView(fireplace: FireplaceState())
            .padding()
    }
}
