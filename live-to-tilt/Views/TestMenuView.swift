import SwiftUI

struct TestMenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Main menu")

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

struct TestMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TestMenuView()
    }
}
