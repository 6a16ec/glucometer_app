import SwiftUI

struct HealthRecommendation: Identifiable {
    var id = UUID()
    var image: Image
    var title: String
    var description: String
}

struct HomeView: View {
    let recommendations = [
            HealthRecommendation(image: Image("sleep"), title: "Get Enough Sleep", description: "Adults need between 7-9 hours of sleep per night."),
            HealthRecommendation(image: Image("water"), title: "Stay Hydrated", description: "Drink at least 8 cups (64 ounces) of water per day."),
            HealthRecommendation(image: Image("steps"), title: "Stay Active", description: "Try to get at least 30 minutes of exercise each day."),
            HealthRecommendation(image: Image("vegetables"), title: "Eat Your Veggies", description: "Eat a variety of fruits and vegetables each day.")
        ]

        var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        ForEach(recommendations) { recommendation in
                            HStack {
                                recommendation.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 75, height: 75)
                                    .padding()
                                VStack(alignment: .leading) {
                                    Text(recommendation.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(.bottom, 1)
                                    Text(recommendation.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationBarTitle("Healthy Recommendations")
            }
        }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
