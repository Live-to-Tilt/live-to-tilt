import CoreGraphics
import SwiftUI

class KeyboardControl: GameControl {
    private var inputForce: CGVector
    private var hasStarted = false

    init() {
        inputForce = .zero
    }

    func start() {
        hasStarted = true
    }

    func stop() {
        hasStarted = false
    }

    func getInputForce() -> CGVector {
        inputForce
    }

    func setInputForce(_ inputForce: CGVector) {
        guard hasStarted else {
            return
        }
        self.inputForce = inputForce
    }

    func handleDirection(_ key: KeyEquivalent) {
        var force: CGVector

        switch key.character {
        case KeyBinding.up.character:
            force = .up
        case KeyBinding.down.character:
            force = .down
        case KeyBinding.left.character:
            force = .left
        case KeyBinding.right.character:
            force = .right
        default:
            return
        }

        setInputForce(force * Constants.defaultSensitivity)
    }
}
