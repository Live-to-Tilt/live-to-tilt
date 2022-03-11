import CoreGraphics

protocol GameControl {
    func start()

    func stop()

    func getInputForce() -> CGVector

    func setInputForce(_ inputForce: CGVector)
}
