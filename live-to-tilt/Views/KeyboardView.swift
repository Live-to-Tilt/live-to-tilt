import SwiftUI

struct KeyboardView: View {
    @StateObject var viewModel = KeyboardViewModel()

    var body: some View {
        Text("x: \(viewModel.gameControl.getAcceleration().x)")
        Text("y: \(viewModel.gameControl.getAcceleration().y)")

        Button(action: { viewModel.handleDirection("w") }) {
            Text("↑")
        }
        .keyboardShortcut("w", modifiers: [])

        Button(action: { viewModel.handleDirection("s") }) {
            Text("↓")
        }
        .keyboardShortcut("s", modifiers: [])

        Button(action: { viewModel.handleDirection("a") }) {
            Text("←")
        }
        .keyboardShortcut("a", modifiers: [])

        Button(action: { viewModel.handleDirection("d") }) {
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
