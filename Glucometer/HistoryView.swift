import SwiftUI

struct HistoryView: View {
    var body: some View {
        GlucoseHistoryView()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}


struct GlucoseHistoryView: View {
    
    @ObservedObject var glucoseData: GlucoseData
    
    var body: some View {
        List {
            ForEach(glucoseData.measurements) { measurement in
                HStack {
                    Text("\(measurement.value) mg/dL")
                    Spacer()
                    Text(dateFormatter.string(from: measurement.date))
                }
            }
        }
        .navigationBarTitle("Glucose History")
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

struct GlucoseMeasurement {
    let value: Int
    let date: Date
}

class GlucoseData: ObservableObject {
    
    @Published var measurements = [GlucoseMeasurement]()
    
    init() {
        // Code to fetch glucose measurements from API or local storage
        // and add them to the measurements array.
        // This depends on how you are storing and fetching the data.
        
        // Example code to add some sample measurements.
        measurements.append(GlucoseMeasurement(value: 100, date: Date()))
        measurements.append(GlucoseMeasurement(value: 120, date: Date().addingTimeInterval(-3600)))
        measurements.append(GlucoseMeasurement(value: 130, date: Date().addingTimeInterval(-7200)))
    }
}

