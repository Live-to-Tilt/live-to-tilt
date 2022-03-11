import SwiftUI

struct KeyboardView: View {
    @StateObject var viewModel = KeyboardViewModel()

    var body: some View {
        Text("x: \(viewModel.gameControl.getInputForce().dx)")
        Text("y: \(viewModel.gameControl.getInputForce().dy)")

        Button(action: { viewModel.gameControl.handleDirection("w") }) {
            Text("↑")
        }
        .keyboardShortcut("w", modifiers: [])

        Button(action: { viewModel.gameControl.handleDirection("s") }) {
            Text("↓")
        }
        .keyboardShortcut("s", modifiers: [])

        Button(action: { viewModel.gameControl.handleDirection("a") }) {
            Text("←")
        }
        .keyboardShortcut("a", modifiers: [])

        Button(action: { viewModel.gameControl.handleDirection("d") }) {
            Text("→")
        }
        .keyboardShortcut("d", modifiers: [])
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}
