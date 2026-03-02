import Foundation
import CoreBluetooth
import Combine

/// Service responsible for communicating with the AquaFire fireplace hardware.
///
/// Currently uses a stub implementation. To connect to real hardware, implement
/// the CoreBluetooth delegate methods and replace the stub commands with actual
/// BLE characteristic writes.
///
/// ## Integration Notes
/// - The AquaFire fireplace typically uses a BLE (Bluetooth Low Energy) module
/// - You will need the service UUID and characteristic UUIDs from the hardware manufacturer
/// - Replace `fireplaceServiceUUID` and `commandCharacteristicUUID` with actual values
class FireplaceService: NSObject, ObservableObject {
    @Published var isConnected: Bool = false
    @Published var isScanning: Bool = false

    // MARK: - BLE Configuration (replace with actual UUIDs from hardware)
    private let fireplaceServiceUUID = CBUUID(string: "0000FFE0-0000-1000-8000-00805F9B34FB")
    private let commandCharacteristicUUID = CBUUID(string: "0000FFE1-0000-1000-8000-00805F9B34FB")

    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var commandCharacteristic: CBCharacteristic?

    override init() {
        super.init()
        // Uncomment to enable BLE scanning on launch:
        // centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // MARK: - Public API

    /// Sends the full fireplace state to the hardware
    func sendState(_ state: FireplaceState) {
        let command = buildCommand(from: state)
        sendCommand(command)
    }

    /// Start scanning for the AquaFire device
    func startScanning() {
        isScanning = true
        centralManager?.scanForPeripherals(withServices: [fireplaceServiceUUID], options: nil)
    }

    /// Disconnect from the current device
    func disconnect() {
        if let peripheral = peripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }

    // MARK: - Command Building

    /// Builds a command byte array from the current fireplace state.
    /// Adjust protocol to match your hardware's expected format.
    private func buildCommand(from state: FireplaceState) -> Data {
        var bytes: [UInt8] = []

        // Header
        bytes.append(0xAA)

        // Power: 0x00 = off, 0x01 = on
        bytes.append(state.isPoweredOn ? 0x01 : 0x00)

        // Flame height (1-5)
        bytes.append(UInt8(state.flameHeight))

        // Flame speed (1-5)
        bytes.append(UInt8(state.flameSpeed))

        // RGB values
        bytes.append(UInt8(state.redValue))
        bytes.append(UInt8(state.greenValue))
        bytes.append(UInt8(state.blueValue))

        // Orange LED: 0x00 = off, 0x01 = on
        bytes.append(state.isOrangeLEDOn ? 0x01 : 0x00)

        // RGB LED: 0x00 = off, 0x01 = on
        bytes.append(state.isRGBLEDOn ? 0x01 : 0x00)

        // Brightness (1-5)
        bytes.append(UInt8(state.brightness))

        // Fade mode: 0x00 = off, 0x01 = on
        bytes.append(state.isFadeActive ? 0x01 : 0x00)

        // Footer
        bytes.append(0x55)

        return Data(bytes)
    }

    private func sendCommand(_ data: Data) {
        // Stub: log command to console during development
        let hex = data.map { String(format: "%02X", $0) }.joined(separator: " ")
        print("[AquaFire] Sending command: \(hex)")

        // When connected to real hardware, write to the BLE characteristic:
        // guard let characteristic = commandCharacteristic else { return }
        // peripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }
}

// MARK: - CBCentralManagerDelegate

extension FireplaceService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScanning()
        case .poweredOff:
            isConnected = false
        default:
            break
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        central.stopScan()
        isScanning = false
        central.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        peripheral.delegate = self
        peripheral.discoverServices([fireplaceServiceUUID])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        // Auto-reconnect after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.startScanning()
        }
    }
}

// MARK: - CBPeripheralDelegate

extension FireplaceService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics([commandCharacteristicUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics where characteristic.uuid == commandCharacteristicUUID {
            commandCharacteristic = characteristic
        }
    }
}
