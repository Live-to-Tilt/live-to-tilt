import SwiftUI

struct PauseMenuView: View {
    @ObservedObject var viewModel: GameArenaViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Game Paused")
            Button(action: { viewModel.resume() }) {
                Text("Resume")
            }

            Button(action: { viewModel.restart() }) {
                Text("Restart")
            }

            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Main Menu")
            }
        }
    }
}

struct PauseMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PauseMenuView(viewModel: GameArenaViewModel())
    }
}
