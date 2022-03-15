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

    // TODO: Improve this, currently a proof of concept
    func handleDirection(_ key: KeyEquivalent) {
        switch key.character {
        case KeyBinding.up.character:
            setInputForce(CGVector.up)
        case KeyBinding.down.character:
            setInputForce(CGVector.down)
        case KeyBinding.left.character:
            setInputForce(CGVector.left)
        case KeyBinding.right.character:
            setInputForce(CGVector.right)
        default:
            return
        }
    }
}
