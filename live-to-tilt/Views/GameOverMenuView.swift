import SwiftUI

struct GameOverMenuView: View {
    @ObservedObject var viewModel: GameArenaViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Group {
            ZStack {
                Image(systemName: "xmark.circle.fill")
                    .modifier(MenuIcon())

                Text("Game Over").modifier(HeroText())
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

struct GameOverMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverMenuView(viewModel: GameArenaViewModel(gameMode: .survival))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
