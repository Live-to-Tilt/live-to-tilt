import SwiftUI

struct PauseMenuView: View {
    @ObservedObject var viewModel: GameArenaViewModel
    @Environment(\.presentationMode) var presentationMode

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

            Button(action: { viewModel.restart() }) {
                Text("Restart").modifier(MenuButton())
            }

            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Main Menu").modifier(MenuButton())
            }
        }.modifier(MenuLayout())
    }
}

struct PauseMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PauseMenuView(viewModel: GameArenaViewModel(gameMode: .survival))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
