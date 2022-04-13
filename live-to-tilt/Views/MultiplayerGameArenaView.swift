import SwiftUI

struct MultiplayerGameArenaView: View {
    @ObservedObject var viewModel = MultiplayerGameArenaViewModel()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            Text("Hello World!")
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            // TODO: dismiss view when opponent disconnects
            // TODO: remove game from firebase when process terminates abruptly
            viewModel.onDisappear()
        }
    }
}

struct MultiplayerGameArenaView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerGameArenaView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
