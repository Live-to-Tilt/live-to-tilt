import SwiftUI

struct GameModeSelectionView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Content()
        }
        .modifier(RootView())
    }

    private func Content() -> some View {
        VStack {
            ForEach(GameMode.allCases) { gameMode in
                NavigationLink(destination: LazyView(
                    GameArenaView(viewModel: GameArenaViewModel(gameMode: gameMode))
                )) {
                    Text(gameMode.rawValue).modifier(MenuItemText())
                }
            }

            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Back")
                    .padding(.top, 40)
            }
        }
    }
}

struct GameModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GameModeSelectionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
