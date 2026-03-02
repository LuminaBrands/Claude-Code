import SwiftUI

struct PowerButton: View {
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer ring glow
                Circle()
                    .stroke(
                        isOn
                            ? LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 3
                    )
                    .frame(width: 72, height: 72)
                    .shadow(color: isOn ? .orange.opacity(0.4) : .clear, radius: 12)

                // Background circle
                Circle()
                    .fill(
                        isOn
                            ? LinearGradient(colors: [Color(red: 0.9, green: 0.3, blue: 0.0), Color(red: 0.8, green: 0.1, blue: 0.0)], startPoint: .top, endPoint: .bottom)
                            : LinearGradient(colors: [Color(white: 0.2), Color(white: 0.15)], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 64, height: 64)

                // Power icon
                Image(systemName: "power")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(isOn ? .white : .gray)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isOn ? "Turn off fireplace" : "Turn on fireplace")
    }
}

#Preview {
    ZStack {
        Color.black
        VStack(spacing: 30) {
            PowerButton(isOn: true, action: {})
            PowerButton(isOn: false, action: {})
        }
    }
}
