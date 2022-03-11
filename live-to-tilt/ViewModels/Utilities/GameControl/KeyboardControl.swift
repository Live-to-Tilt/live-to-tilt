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

    func setInputForce(_ inputForce: CGVector) {
        guard hasStarted else {
            return
        }
        self.inputForce = inputForce
    }

    // TODO: Improve this, currently a proof of concept
    func handleDirection(_ key: String) {
        switch key {
        case "w":
            setInputForce(CGVector(dx: 1, dy: 0))
        case "s":
            setInputForce(CGVector(dx: -1, dy: 0))
        case "a":
            setInputForce(CGVector(dx: 0, dy: 1))
        case "d":
            setInputForce(CGVector(dx: 0, dy: -1))
        default:
            return
        }
    }
}
