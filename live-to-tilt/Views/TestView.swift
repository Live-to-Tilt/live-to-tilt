import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Main Menu")

                NavigationLink(destination: TestGameView()) {
                    Text("Start game")
                }

                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
