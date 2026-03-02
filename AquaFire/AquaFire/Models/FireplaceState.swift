import SwiftUI
import Combine

/// Represents a preset color available on the AquaFire remote
struct PresetColor: Identifiable, Equatable {
    let id = UUID()
    let color: Color
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let name: String

    static func == (lhs: PresetColor, rhs: PresetColor) -> Bool {
        lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b
    }
}

/// All preset colors from the AquaFire remote, arranged in rows
enum PresetColors {
    static let all: [PresetColor] = [
        // Row 1 - Warm tones
        PresetColor(color: Color(red: 1.0, green: 0.35, blue: 0.0), r: 255, g: 89, b: 0, name: "Orange Red"),
        PresetColor(color: Color(red: 1.0, green: 0.55, blue: 0.0), r: 255, g: 140, b: 0, name: "Dark Orange"),
        PresetColor(color: Color(red: 1.0, green: 0.75, blue: 0.0), r: 255, g: 191, b: 0, name: "Amber"),
        PresetColor(color: Color(red: 1.0, green: 0.9, blue: 0.3), r: 255, g: 230, b: 77, name: "Yellow"),
        // Row 2 - Greens
        PresetColor(color: Color(red: 0.0, green: 0.8, blue: 0.2), r: 0, g: 204, b: 51, name: "Green"),
        PresetColor(color: Color(red: 0.0, green: 0.9, blue: 0.6), r: 0, g: 230, b: 153, name: "Mint"),
        PresetColor(color: Color(red: 0.0, green: 0.8, blue: 0.8), r: 0, g: 204, b: 204, name: "Teal"),
        PresetColor(color: Color(red: 0.2, green: 0.9, blue: 0.4), r: 51, g: 230, b: 102, name: "Light Green"),
        // Row 3 - Blues
        PresetColor(color: Color(red: 0.0, green: 0.5, blue: 1.0), r: 0, g: 128, b: 255, name: "Blue"),
        PresetColor(color: Color(red: 0.0, green: 0.3, blue: 0.9), r: 0, g: 77, b: 230, name: "Royal Blue"),
        PresetColor(color: Color(red: 0.3, green: 0.2, blue: 1.0), r: 77, g: 51, b: 255, name: "Indigo"),
        PresetColor(color: Color(red: 0.1, green: 0.6, blue: 1.0), r: 26, g: 153, b: 255, name: "Sky Blue"),
        // Row 4 - Purples & Pinks
        PresetColor(color: Color(red: 0.6, green: 0.0, blue: 1.0), r: 153, g: 0, b: 255, name: "Purple"),
        PresetColor(color: Color(red: 0.8, green: 0.0, blue: 0.8), r: 204, g: 0, b: 204, name: "Magenta"),
        PresetColor(color: Color(red: 1.0, green: 0.2, blue: 0.6), r: 255, g: 51, b: 153, name: "Pink"),
        PresetColor(color: Color(red: 1.0, green: 1.0, blue: 1.0), r: 255, g: 255, b: 255, name: "White"),
    ]
}

/// Central state for the AquaFire fireplace
class FireplaceState: ObservableObject {
    // MARK: - Power
    @Published var isPoweredOn: Bool = false

    // MARK: - Flame Controls
    @Published var flameHeight: Int = 3      // 1–5
    @Published var flameSpeed: Int = 3       // 1–5

    static let minLevel = 1
    static let maxLevel = 5

    // MARK: - Color
    @Published var selectedColor: PresetColor? = nil
    @Published var redValue: Double = 255
    @Published var greenValue: Double = 100
    @Published var blueValue: Double = 0

    var currentColor: Color {
        Color(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255)
    }

    // MARK: - LED Toggles
    @Published var isOrangeLEDOn: Bool = true
    @Published var isRGBLEDOn: Bool = false

    // MARK: - Brightness
    @Published var brightness: Int = 3       // 1–5

    // MARK: - Fade Mode
    @Published var isFadeActive: Bool = false

    // MARK: - Actions

    func togglePower() {
        isPoweredOn.toggle()
    }

    func increaseFlameHeight() {
        if flameHeight < Self.maxLevel { flameHeight += 1 }
    }

    func decreaseFlameHeight() {
        if flameHeight > Self.minLevel { flameHeight -= 1 }
    }

    func increaseFlameSpeed() {
        if flameSpeed < Self.maxLevel { flameSpeed += 1 }
    }

    func decreaseFlameSpeed() {
        if flameSpeed > Self.minLevel { flameSpeed -= 1 }
    }

    func increaseBrightness() {
        if brightness < Self.maxLevel { brightness += 1 }
    }

    func decreaseBrightness() {
        if brightness > Self.minLevel { brightness -= 1 }
    }

    func selectPresetColor(_ preset: PresetColor) {
        selectedColor = preset
        redValue = Double(preset.r)
        greenValue = Double(preset.g)
        blueValue = Double(preset.b)
        isRGBLEDOn = true
    }

    func toggleFade() {
        isFadeActive.toggle()
        if isFadeActive {
            isRGBLEDOn = true
        }
    }

    func toggleOrangeLED() {
        isOrangeLEDOn.toggle()
    }

    func toggleRGBLED() {
        isRGBLEDOn.toggle()
        if !isRGBLEDOn {
            isFadeActive = false
        }
    }
}
