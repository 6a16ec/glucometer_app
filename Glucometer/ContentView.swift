import SwiftUI
import Firebase

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn: Bool = false
    @StateObject var glucoseData = GlucoseData()
    var body: some View {
        if userIsLoggedIn {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "folder")
                    }
                StatisticsView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.pie")
                    }
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "list.dash")
                    }
                    .environmentObject(glucoseData)
                SettingsView(userIsLoggedIn: $userIsLoggedIn)
                    .tabItem {
                        Label("Settings", systemImage: "person.crop.circle.fill")
                    }
                    .environmentObject(glucoseData)
            }
            
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            Color.black
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            VStack(spacing: 20) {
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -100, y: -100)
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                  
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Button {
                    register()
                } label: {
                    Text("Sign up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 100)
                
                Button {
                    login()
                } label: {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 110)
                
            }
            .frame(width: 350)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        userIsLoggedIn.toggle()
                    }
                    
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}



class GlucoseData: ObservableObject {
    
    @Published var measurements = [GlucoseMeasurement]()
    
    init() {
        // Code to fetch glucose measurements from API or local storage
        // and add them to the measurements array.
        // This depends on how you are storing and fetching the data.
        
        // Example code to add some sample measurements.
        measurements.append(GlucoseMeasurement(value: 100, date: Date().addingTimeInterval(-7200)))
        measurements.append(GlucoseMeasurement(value: 110, date: Date().addingTimeInterval(-3600)))
        measurements.append(GlucoseMeasurement(value: 105, date: Date()))
    }
}
