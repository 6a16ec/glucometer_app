struct StatisticsView: View {
    
    @State var chartData = [ChartData]()
    
    var body: some View {
        VStack {
            Spacer()
            LineChartView(data: chartData)
                .frame(height: 200)
            Spacer()
        }
        .onAppear() {
            fetchData()
        }
    }
    
    func fetchData() {
        let endpoint = "http://45.12.75.194/data"
        guard let url = URL(string: endpoint) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            do {
                let jsonData = try JSONDecoder().decode([ChartData].self, from: data)
                DispatchQueue.main.async {
                    self.chartData = jsonData
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
}

struct ChartData: Codable {
    let xValue: CGFloat
    let yValue: CGFloat
}

struct LineChartView: View {
    var data: [ChartData]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let scaleX = geometry.size.width / (data.last?.xValue ?? 1)
                let scaleY = geometry.size.height / (data.last?.yValue ?? 1)
                data.forEach { point in
                    let x = point.xValue * scaleX
                    let y = geometry.size.height - (point.yValue * scaleY)
                    if point == data.first {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(lineWidth: 2)
            .foregroundColor(.blue)
        }
    }
}
