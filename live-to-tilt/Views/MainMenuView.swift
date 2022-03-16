import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Live to Tilt").modifier(TitleText())

                let gameArenaView = GameArenaView(viewModel: GameArenaViewModel())
                NavigationLink(destination: gameArenaView) {
                    Text("Play").modifier(CapsuleText())
                }

                let settingsView = SettingsView()
                NavigationLink(destination: settingsView) {
                    Text("Settings").modifier(CapsuleText())
                }
            }
            .modifier(RootView())
        }
        .navigationViewStyle(.stack)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}