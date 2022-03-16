import SwiftUI

struct GameControlView: View {
    @Binding var gameControl: GameControl

    var body: some View {
        VStack {
            Text("x: \(gameControl.getInputForce().dx)")
            Text("y: \(gameControl.getInputForce().dy)")

            if let keyboardControl = gameControl as? KeyboardControl {
                KeyboardControls(keyboardControl)
            } else if let accelControl = gameControl as? AccelerometerControl {
                AccelerometerControls(accelControl)
            }
        }
    }

    private func KeyboardControls(_ keyboardControl: KeyboardControl) -> some View {
        VStack {
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

    private func AccelerometerControls(_ accelControl: AccelerometerControl) -> some View {
        Text("Accelerometer control")
    }
}
