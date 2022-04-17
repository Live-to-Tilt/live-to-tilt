import SwiftUI

struct GameModeSelectionView: View {
    @State var selectedGameMode: GameMode = .survival
    @Environment(\.presentationMode) private var presentationMode

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
            SubViewHeader(title: "Select Gamemode", closeButtonAction: { self.presentationMode.wrappedValue.dismiss() })

            GameModePicker(selectedGameMode: $selectedGameMode)

            GameModeInfo()

            if selectedGameMode == .coop {
                NavigationLink(destination: LazyView(MultiplayerLobbyView())) {
                    Text("Start").modifier(MenuButton())
                }
                .modifier(TapSoundEffect())
            } else {
                NavigationLink(destination: LazyView(
                    SingleplayerGameArenaView(viewModel: SingleplayerGameArenaViewModel(gameMode: selectedGameMode))
                )) {
                    Text("Start").modifier(MenuButton())
                }
                .modifier(TapSoundEffect())
            }
        }
        .frame(width: 700)
    }

    private func GameModeInfo() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(selectedGameMode.rawValue)
                    .modifier(HeadingOneText())

                Spacer()

                Text("🏆 \(AllTimeStats.shared.getHighScore(for: selectedGameMode))")
                    .font(.system(size: 24))
            }

            Text(selectedGameMode.description)
                .font(.system(size: 24))
        }
        .padding(.bottom, 50)
        .frame(width: 600)
    }
}

struct GameModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GameModeSelectionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
