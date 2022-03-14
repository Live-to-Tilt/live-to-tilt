import SwiftUI

struct TestView: View {
    @StateObject var viewModel = TestViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("This is a test view")

                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }

                // Insert this view into any view to allow player controls
                GameControlView(gameControl: $viewModel.gameControl)
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
