import SwiftUI
import Foundation


struct HomeView: View {
    
    @ObservedObject var glucoseData: GlucoseData
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Last Measurement: \(glucoseData.lastMeasurement?.value ?? 0) mg/dL on \(glucoseData.lastMeasurement?.dateString() ?? "")")
                    .padding()
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Data for This Week")
                        .font(.headline)
                        .padding(.bottom)
                    
                    HStack {
                        Text("Average Glucose:")
                        Spacer()
                        Text("\(glucoseData.averageGlucoseThisWeek) mg/dL")
                    }
                    
                    HStack {
                        Text("Maximum Glucose:")
                        Spacer()
                        Text("\(glucoseData.maxGlucoseThisWeek) mg/dL")
                    }
                    
                    HStack {
                        Text("Minimum Glucose:")
                        Spacer()
                        Text("\(glucoseData.minGlucoseThisWeek) mg/dL")
                    }
                }
                .padding()
            }
            .navigationBarTitle("Glucose Settings")
        }
    }
}

extension GlucoseMeasurement {
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

class GlucoseData: ObservableObject {
    
    @Published var measurements = [GlucoseMeasurement]()
    
    var lastMeasurement: GlucoseMeasurement? {
        return measurements.last
    }
    
    var averageGlucoseThisWeek: Double {
        let weekAgo = Date().addingTimeInterval(-604800)
        let weekMeasurements = measurements.filter { $0.date > weekAgo }
        let total = weekMeasurements.reduce(0) { $0 + $1.value }
        let count = Double(weekMeasurements.count)
        return count > 0 ? total / count : 0
    }
    
    var maxGlucoseThisWeek: Int {
        let weekAgo = Date().addingTimeInterval(-604800)
        let weekMeasurements = measurements.filter { $0.date > weekAgo }
        return weekMeasurements.max { a, b in a.value < b.value }?.value ?? 0
    }
    
    var minGlucoseThisWeek: Int {
        let weekAgo = Date().addingTimeInterval(-604800)
        let weekMeasurements = measurements.filter { $0.date > weekAgo }
        return weekMeasurements.min { a, b in a.value < b.value }?.value ?? 0
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
