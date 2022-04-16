import SwiftUI

struct MultiplayerLobbyView: View {
    @StateObject var viewModel = MultiplayerLobbyViewModel()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        // TODO: dismiss view when opponent disconnects
        // TODO: remove game from firebase when process terminates abruptly
        NavigationView {
            Content()
        }
        .navigationViewStyle(.stack)
    }

    private func Content() -> some View {
        VStack {
            Text("Host: \(viewModel.hostId)")
            Text("Guest: \(viewModel.guestId)")

            NavigationLink(destination: LazyView(
                MultiplayerGameArenaView(viewModel: MultiplayerGameArenaViewModel(roomManager: viewModel.roomManager))),
                           isActive: $viewModel.displayArena) {
                EmptyView()
            }
        }
        .onFirstAppear {
            viewModel.onAppear()
        }
        .navigationBarHidden(viewModel.gameStarted)
    }
}

struct MultiplayerLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerLobbyView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
