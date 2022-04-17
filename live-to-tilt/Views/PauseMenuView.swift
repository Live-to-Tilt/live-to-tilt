import SwiftUI

struct PauseMenuView: View {
    var viewModel: Pausable
    @Environment(\.rootPresentationMode) private var rootPresentationMode

    var body: some View {
        Group {
            ZStack {
                Image(systemName: "pause.fill")
                    .modifier(MenuIcon())

                Text("Game Paused").modifier(HeroText())
            }

            Button(action: { viewModel.resume() }) {
                Text("Resume").modifier(MenuButton())
            }
            .modifier(TapSoundEffect())

            Button(action: { viewModel.restart() }) {
                Text("Restart").modifier(MenuButton())
            }
            .modifier(TapSoundEffect())

            Button(action: { self.rootPresentationMode.wrappedValue.dismiss() }) {
                Text("Main Menu").modifier(MenuButton())
            }
            .modifier(TapSoundEffect())
        }.modifier(MenuLayout())
    }
}

struct PauseMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PauseMenuView(viewModel: SingleplayerGameArenaViewModel(gameMode: .survival))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
