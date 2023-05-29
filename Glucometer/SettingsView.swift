import SwiftUI
import CoreBluetooth


struct SettingsView: View {
    
    @StateObject var bluetoothManager = BluetoothManager()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Bluetooth Status")) {
                    Text(bluetoothManager.statusDescription)
                }
                Section(header: Text("Available Devices")) {
                    ForEach(bluetoothManager.peripherals, id: \.self) { peripheral in
                        Button(action: {
                            bluetoothManager.connect(to: peripheral)
                        }) {
                            Text(peripheral.name ?? "Unknown")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationBarTitle("Bluetooth Settings")
        }
        .onAppear {
            bluetoothManager.startScanning()
        }
        .onDisappear {
            bluetoothManager.stopScanning()
        }
    }
}

final class BluetoothManager: NSObject, ObservableObject {
    
    private let serviceUUID = CBUUID(string: "MY_SERVICE_UUID")
    private let characteristicUUID = CBUUID(string: "MY_CHARACTERISTIC_UUID")
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    
    @Published var peripherals = [CBPeripheral]()
    @Published var isConnected = false
    @Published var statusDescription = "Bluetooth is not connected"
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func connect(to peripheral: CBPeripheral) {
        stopScanning()
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            statusDescription = "Bluetooth is active"
        default:
            statusDescription = "Bluetooth is not active"
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        statusDescription = "Bluetooth is connected to \(peripheral.name ?? "Unknown")"
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        statusDescription = "Bluetooth failed to connect to (peripheral.name ?? "Unknown")" }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        statusDescription = "Bluetooth disconnected from \(peripheral.name ?? "Unknown")"
    }

    }

    extension BluetoothManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services where service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics where characteristic.uuid == characteristicUUID {
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value {
            // Use value data here to update UI or perform other actions
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
