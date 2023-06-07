import SwiftUI
import Firebase

struct BluetoothDevice: Identifiable {
    let id = UUID()
    var name: String
    var isConnected: Bool
}

struct SettingsView: View {
    @EnvironmentObject var glucoseData: GlucoseData
    @Binding var userIsLoggedIn: Bool
    
    @State private var devices = [
            BluetoothDevice(name: "Glucometer AB", isConnected: true),
            BluetoothDevice(name: "HC-05", isConnected: false),
            BluetoothDevice(name: "Iphone (Nikita)", isConnected: false),
            BluetoothDevice(name: "JBL Flip 4", isConnected: false)
        ]
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Available Devices")
                .font(.largeTitle)
                .padding()
            
            List(devices) { device in
                HStack {
                    Text(device.name)
                        .font(.title)
                    
                    Spacer()
                    
                    if device.isConnected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(height: 300)
            
            Spacer()
            
            Button(action: {
                // Do something when user selects a device
            }) {
                Text("Connect")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    self.userIsLoggedIn = false
                } catch let error {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }) {
                Text("Sign Out")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.white))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            
            Button(action: {
                do {
                    let value = Int.random(in: 85..<120)
                    glucoseData.measurements.append(GlucoseMeasurement(value: value, date: Date()))
                    print("glucoseData.measurements: \(glucoseData.measurements.count)")
                    putMeasurements(value: value)
                }
            }) {
                Text("Add Glucose Measurement")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.white))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            Spacer()
        }
        .navigationBarTitle("Settings")
    }
    
    func putMeasurements(value: Int) {
        let userID = Auth.auth().currentUser!.uid
        print("userID: \(userID)")
        guard let url = URL(string: "http://45.12.75.194/put/?user_id=\(userID)&value=\(value)") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
        }

        dataTask.resume()
    }
}


struct SettingsView_Previews: PreviewProvider {
    @State static var userIsLoggedIn = true
    static var previews: some View {
        SettingsView(userIsLoggedIn: $userIsLoggedIn)
    }
}
