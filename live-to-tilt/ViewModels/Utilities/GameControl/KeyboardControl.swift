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
        var newForce: CGVector

        switch key.character {
        case KeyBinding.up.character:
            newForce = CGVector.up
        case KeyBinding.down.character:
            newForce = CGVector.down
        case KeyBinding.left.character:
            newForce = CGVector.left
        case KeyBinding.right.character:
            newForce = CGVector.right
        case KeyBinding.brake.character:
            setInputForce(.zero)
            return
        default:
            return
        }

        var force = inputForce + newForce
        if force.dx != 0 {
            force.dx = force.dx > 0 ? min(0.5, force.dx) : max(-0.5, force.dx)
        }
        if force.dy != 0 {
            force.dy = force.dy > 0 ? min(0.5, force.dy) : max(-0.5, force.dy)
        }

        setInputForce(force)
    }
}
