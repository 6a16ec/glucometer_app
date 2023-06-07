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
    @EnvironmentObject var glucoseData: GlucoseData
    
    var body: some View {
        List {
            ForEach(glucoseData.measurements) { measurement in
                HStack {
                    Text("\(measurement.value) mg/dL")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    Spacer()
                    Text(dateFormatter.string(from: measurement.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
        }
        .listStyle(DefaultListStyle())
        .navigationBarTitle("Glucose History")
        .background(Color.white)
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

struct GlucoseMeasurement: Identifiable {
    let id = UUID()
    let value: Int
    let date: Date
}
