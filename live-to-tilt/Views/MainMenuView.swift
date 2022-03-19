import SwiftUI

struct MainMenuView: View {
    @StateObject var viewModel = MainMenuViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Live to Tilt").modifier(TitleText())

                NavigationLink(destination: LazyView(
                    GameArenaView(viewModel: GameArenaViewModel())
                )) {
                    Text("Play").modifier(CapsuleText())
                }

                let settingsView = SettingsView()
                NavigationLink(destination: settingsView) {
                    Text("Settings").modifier(CapsuleText())
                }
            }
            .modifier(RootView())
            .onAppear {
                viewModel.onAppear()
            }
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
