import SwiftUI

struct GameModeSelectionView: View {
    @State var selectedGameMode: GameMode = .survival
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Content()
                .modifier(RootView())
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }

    private func Content() -> some View {
        VStack {
            Text("Select Gamemode").modifier(TitleText())

            GameModePicker()

            GameModeInfo()

            Buttons()
        }
        .frame(width: 700)
    }

    private func GameModePicker() -> some View {
        HStack {
            ForEach(GameMode.allCases) { gameMode in
                GameModeButton(gameMode: gameMode)
            }
        }
        .padding(15)
        .border(.white, width: 5)
    }

    private func GameModeButton(gameMode: GameMode) -> some View {
        Button(action: { selectedGameMode = gameMode }) {
            Text(gameMode.emoji)
                .font(.system(size: 48))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(selectedGameMode == gameMode ? Color(red: 0.84, green: 0.24, blue: 0.20) : .clear)
        }
    }

    private func GameModeInfo() -> some View {
        VStack {
            Text(selectedGameMode.rawValue)
                .modifier(HeadingOneText())
            Text(selectedGameMode.description)
                .font(.system(size: 24))
        }
        .padding(.bottom, 50)
        .frame(width: 600)
    }

    private func Buttons() -> some View {
        HStack {
            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Back").modifier(MenuButton(width: 200))
            }

            NavigationLink(destination: LazyView(
                GameArenaView(viewModel: GameArenaViewModel(gameMode: selectedGameMode))
            )) {
                Text("Start").modifier(MenuButton(width: 200))
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
