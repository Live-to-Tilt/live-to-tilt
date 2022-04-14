import SwiftUI

struct MultiplayerLobbyView: View {
    @ObservedObject var viewModel = MultiplayerLobbyViewModel()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        // TODO: dismiss view when opponent disconnects
        // TODO: remove game from firebase when process terminates abruptly
        VStack {
            Text("Host: \(viewModel.hostId)")
            Text("Guest: \(viewModel.guestId)")

            NavigationLink(destination: LazyView(
                MultiplayerGameArenaView(viewModel: MultiplayerGameArenaViewModel(gameManager: viewModel.gameManager))),
                           isActive: $viewModel.displayArena) {
                EmptyView()
            }
        }
        .onAppear {
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
