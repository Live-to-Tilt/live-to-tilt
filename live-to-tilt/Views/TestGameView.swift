import SwiftUI

struct TestGameView: View {
    @StateObject var viewModel = TestGameViewModel()

    var body: some View {
        VStack {
            Text("Test view of a running game")

            // Insert this view into any view to allow player controls
            GameControlView(gameControl: $viewModel.gameControl)
        }
    }
}

struct TestGameView_Previews: PreviewProvider {
    static var previews: some View {
        TestGameView()
    }
}
