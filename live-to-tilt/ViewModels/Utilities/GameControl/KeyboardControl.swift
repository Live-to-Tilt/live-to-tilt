import CoreGraphics

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

    func setAcceleration(_ inputForce: CGVector) {
        guard hasStarted else {
            return
        }
        self.inputForce = inputForce
    }
}
