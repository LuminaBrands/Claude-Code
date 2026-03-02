import SwiftUI

struct ContentView: View {
    @StateObject private var fireplace = FireplaceState()
    @StateObject private var service = FireplaceService()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.12),
                    Color(red: 0.1, green: 0.08, blue: 0.18)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView

                    if fireplace.isPoweredOn {
                        // Flame Controls
                        FlameControlView(fireplace: fireplace)

                        // Color Picker
                        ColorPickerView(fireplace: fireplace)

                        // LED Controls
                        LEDControlView(fireplace: fireplace)

                        // Brightness
                        BrightnessControlView(fireplace: fireplace)

                        // Fade
                        FadeControlView(fireplace: fireplace)
                    }

                    // Connection status
                    connectionStatus
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: fireplace.isPoweredOn) { _ in service.sendState(fireplace) }
        .onChange(of: fireplace.flameHeight) { _ in service.sendState(fireplace) }
        .onChange(of: fireplace.flameSpeed) { _ in service.sendState(fireplace) }
        .onChange(of: fireplace.redValue) { _ in service.sendState(fireplace) }
        .onChange(of: fireplace.greenValue) { _ in service.sendState(fireplace) }
        .onChange(of: fireplace.blueValue) { _ in service.sendState(fireplace) }
        .onChange(of: fireplace.isOrangeLEDOn) { _ in service.sendState(fireplace) }
        .onChange(of: fireplace.isRGBLEDOn) { _ in service.sendState(fireplace) }
        .onChange(of: fireplace.brightness) { _ in service.sendState(fireplace) }
        .onChange(of: fireplace.isFadeActive) { _ in service.sendState(fireplace) }
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: 16) {
            // Flame animation icon
            Image(systemName: fireplace.isPoweredOn ? "flame.fill" : "flame")
                .font(.system(size: 44))
                .foregroundStyle(
                    fireplace.isPoweredOn
                        ? LinearGradient(colors: [.orange, .red], startPoint: .bottom, endPoint: .top)
                        : LinearGradient(colors: [.gray, .gray.opacity(0.6)], startPoint: .bottom, endPoint: .top)
                )
                .symbolEffect(.pulse, isActive: fireplace.isPoweredOn && fireplace.isFadeActive)

            Text("AQUAFIRE")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .tracking(6)
                .foregroundColor(.white)

            Text("Electric Fireplace")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.5))

            // Power Button
            PowerButton(isOn: fireplace.isPoweredOn) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    fireplace.togglePower()
                }
            }
        }
        .padding(.top, 20)
    }

    // MARK: - Connection Status

    private var connectionStatus: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(service.isConnected ? .green : .orange)
                .frame(width: 8, height: 8)
            Text(service.isConnected ? "Connected" : "Searching for AquaFire...")
                .font(.caption)
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.top, 8)
    }
}

#Preview {
    ContentView()
}
