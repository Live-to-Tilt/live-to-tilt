import SwiftUI

struct GameControlView: View {
    @Binding var gameControl: GameControl

    var body: some View {
        HStack {
            Text("x: \(gameControl.getInputForce().dx)")
            Text("y: \(gameControl.getInputForce().dy)")

            if let keyboardControl = gameControl as? KeyboardControl {
                KeyboardControls(keyboardControl)
            }
        }
        .opacity(0)
        .allowsHitTesting(false)
    }

    private func KeyboardControls(_ keyboardControl: KeyboardControl) -> some View {
        HStack {
            Text("Keyboard control")
            Button(action: { keyboardControl.handleDirection(KeyBinding.up) }) {
                Text("↑")
            }
            .keyboardShortcut(KeyBinding.up, modifiers: [])

            Button(action: { keyboardControl.handleDirection(KeyBinding.down) }) {
                Text("↓")
            }
            .keyboardShortcut(KeyBinding.down, modifiers: [])

            Button(action: { keyboardControl.handleDirection(KeyBinding.left) }) {
                Text("←")
            }
            .keyboardShortcut(KeyBinding.left, modifiers: [])

            Button(action: { keyboardControl.handleDirection(KeyBinding.right) }) {
                Text("→")
            }
            .keyboardShortcut(KeyBinding.right, modifiers: [])
        }
    }
}
