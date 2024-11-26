import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Pestaña de carros
            NavigationView {
                ContentView()
            }
            .tabItem {
                Image(systemName: "car.fill")
                Text("Carros")
            }
        }
    }
}

#Preview {
    MainTabView()
}
