import SwiftUI

struct GameOverMenuView: View {
    @ObservedObject var viewModel: GameArenaViewModel
    @Environment(\.rootPresentationMode) private var rootPresentationMode

    var body: some View {
        Group {
            ZStack {
                Image(systemName: "xmark.circle.fill")
                    .modifier(MenuIcon())

                Text("Game Over").modifier(HeroText())
            }

            Text("Score: \(viewModel.gameEngine.gameStats.score)")
            Text("Time: \(viewModel.gameEngine.gameStats.playTime.toTimeString())")
            Text("Dead Dots: \(viewModel.gameEngine.gameStats.enemiesKilled)")

            Button(action: { viewModel.restart() }) {
                Text("Restart").modifier(MenuButton())
            }

            Button(action: { self.rootPresentationMode.wrappedValue.dismiss() }) {
                Text("Main Menu").modifier(MenuButton())
            }
        }.modifier(MenuLayout())
    }
}

struct GameOverMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverMenuView(viewModel: GameArenaViewModel(gameMode: .survival))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
