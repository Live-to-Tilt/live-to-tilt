import SwiftUI

struct GameOverMenuView: View {
    @ObservedObject var viewModel: GameArenaViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Game Over")
            Button(action: { viewModel.restart() }) {
                Text("Restart")
            }

            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Main Menu")
            }
        }
    }
}

struct GameOverMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverMenuView(viewModel: GameArenaViewModel())
    }
}
