import SwiftUI

struct MultiplayerLobbyView: View {
    @StateObject var viewModel = MultiplayerLobbyViewModel()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Content()
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }

    private func Content() -> some View {
        VStack {
            if viewModel.gameStarting {
                Text("Game starting...").modifier(TitleText())
            } else {
                SubViewHeader(title: "Waiting for players",
                              closeButtonAction: { self.presentationMode.wrappedValue.dismiss() })
            }

            Text("Host: \(viewModel.hostId)")
            Text("Guest: \(viewModel.guestId)")

            NavigationLink(destination: LazyView(
                MultiplayerGameArenaView(viewModel: MultiplayerGameArenaViewModel(
                    roomManager: viewModel.roomManager,
                    messageManager: viewModel.messageManager))),
                           isActive: $viewModel.displayArena) {
                EmptyView()
            }
        }
        .onFirstAppear {
            viewModel.onAppear()
        }
        .frame(width: 700)
    }
}

struct MultiplayerLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerLobbyView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
