import SwiftUI

struct ColorPickerView: View {
    @ObservedObject var fireplace: FireplaceState

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)

    var body: some View {
        CardView {
            VStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "paintpalette.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 14))
                    Text("Color")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }

                // Color preview
                RoundedRectangle(cornerRadius: 12)
                    .fill(fireplace.currentColor)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: fireplace.currentColor.opacity(0.4), radius: 8)

                // Preset color grid
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(PresetColors.all) { preset in
                        colorSwatch(preset)
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.1))

                // RGB Sliders
                VStack(spacing: 12) {
                    rgbSlider(label: "R", value: $fireplace.redValue, color: .red)
                    rgbSlider(label: "G", value: $fireplace.greenValue, color: .green)
                    rgbSlider(label: "B", value: $fireplace.blueValue, color: .blue)
                }
            }
        }
    }

    private func colorSwatch(_ preset: PresetColor) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                fireplace.selectPresetColor(preset)
            }
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .fill(preset.color)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            fireplace.selectedColor == preset ? Color.white : Color.clear,
                            lineWidth: 2
                        )
                )
                .shadow(
                    color: fireplace.selectedColor == preset ? preset.color.opacity(0.6) : .clear,
                    radius: 6
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(preset.name)
    }

    private func rgbSlider(label: String, value: Binding<Double>, color: Color) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(color)
                .frame(width: 20)

            Slider(value: value, in: 0...255, step: 1)
                .tint(color)
                .onChange(of: value.wrappedValue) { _ in
                    fireplace.selectedColor = nil
                }

            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 36, alignment: .trailing)
        }
    }
}

#Preview {
    ZStack {
        Color.black
        ColorPickerView(fireplace: FireplaceState())
            .padding()
    }
}
