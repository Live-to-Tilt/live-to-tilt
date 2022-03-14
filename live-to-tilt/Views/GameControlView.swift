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
            Button(action: { keyboardControl.handleDirection("w") }) {
                Text("↑")
            }
            .keyboardShortcut("w", modifiers: [])

            Button(action: { keyboardControl.handleDirection("s") }) {
                Text("↓")
            }
            .keyboardShortcut("s", modifiers: [])

            Button(action: { keyboardControl.handleDirection("a") }) {
                Text("←")
            }
            .keyboardShortcut("a", modifiers: [])

            Button(action: { keyboardControl.handleDirection("d") }) {
                Text("→")
            }
            .keyboardShortcut("d", modifiers: [])
        }
    }

    private func AccelerometerControls(_ accelControl: AccelerometerControl) -> some View {
        Text("Accelerometer control")
    }
}
