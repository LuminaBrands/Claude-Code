import SwiftUI

struct FlameControlView: View {
    @ObservedObject var fireplace: FireplaceState

    var body: some View {
        CardView {
            VStack(spacing: 20) {
                // Flame Height
                controlRow(
                    icon: "flame.fill",
                    label: "Flame Height",
                    value: fireplace.flameHeight,
                    onDecrease: { fireplace.decreaseFlameHeight() },
                    onIncrease: { fireplace.increaseFlameHeight() }
                )

                Divider()
                    .background(Color.white.opacity(0.1))

                // Flame Speed
                controlRow(
                    icon: "wind",
                    label: "Flame Speed",
                    value: fireplace.flameSpeed,
                    onDecrease: { fireplace.decreaseFlameSpeed() },
                    onIncrease: { fireplace.increaseFlameSpeed() }
                )
            }
        }
    }

    private func controlRow(
        icon: String,
        label: String,
        value: Int,
        onDecrease: @escaping () -> Void,
        onIncrease: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(.orange)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }

            HStack(spacing: 20) {
                // Minus button
                StepperButton(systemName: "minus", action: onDecrease)

                // Level indicator
                HStack(spacing: 6) {
                    ForEach(1...FireplaceState.maxLevel, id: \.self) { level in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(level <= value ? Color.orange : Color.white.opacity(0.1))
                            .frame(width: 28, height: 8)
                            .animation(.easeInOut(duration: 0.2), value: value)
                    }
                }

                // Plus button
                StepperButton(systemName: "plus", action: onIncrease)
            }
        }
    }
}

struct StepperButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.black
        FlameControlView(fireplace: FireplaceState())
            .padding()
    }
}
