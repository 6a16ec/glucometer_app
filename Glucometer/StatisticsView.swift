import SwiftUI


struct StatisticsView: View {
    @State private var dataPoints = [
        ("Jan", 50.0),
        ("Feb", 20.0),
        ("Mar", 80.0),
        ("Apr", 30.0),
        ("May", 100.0),
        ("Jun", 60.0),
        ("Jul", 10.0),
        ("Aug", 70.0),
        ("Sep", 90.0),
        ("Oct", 40.0),
        ("Nov", 75.0),
        ("Dec", 55.0)
    ]
    
    var body: some View {
        VStack {
            Text("Pie Chart")
                .font(.largeTitle)
                .padding()

            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(0..<dataPoints.count) { index in
                        PieChartSlice(startAngle: index == 0 ? 0 : dataPoints[index-1].1/100 * 360, endAngle: dataPoints[index].1/100 * 360)
                            .frame(width: geometry.size.width/CGFloat(dataPoints.count))
                            .padding(.vertical, 10)
                    }
                }
            }
            .frame(height: 300)
            
            Spacer()
        }
    }
}

struct PieChartSlice: View {
    let startAngle: Double
    let endAngle: Double
    
    var body: some View {
        let strokeStyle = StrokeStyle(lineWidth: 50, lineCap: .round, lineJoin: .round)
        let endAngle = Double(360-90)
        let startAngle = Double(-90)

        return ZStack {
            Circle()
                .trim(from: 0, to: 0.99)
                .stroke(Color.gray.opacity(0.4), style: strokeStyle)
            Circle()
                .trim(from: 0, to: 0.01)
                .stroke(Color.green, style: strokeStyle)
                .rotationEffect(.degrees(startAngle.degreesToRadians()))
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            Circle()
                .trim(from: 0, to: 0.01)
                .stroke(Color.red, style: strokeStyle)
                .rotationEffect(.degrees(endAngle.degreesToRadians()))
        }
        .rotationEffect(.degrees(-90))
    }
}

extension Double {
    func degreesToRadians() -> Double {
        return self * .pi / 180
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
