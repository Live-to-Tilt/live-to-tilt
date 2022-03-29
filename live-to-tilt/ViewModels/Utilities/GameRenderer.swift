import QuartzCore

class GameRenderer {
    private let gameEngine: GameEngine
    private var displayLink: CADisplayLink!
    private var gameControl: GameControl
    private var hasStarted = false

    init(gameEngine: GameEngine, gameControl: GameControl) {
        self.gameEngine = gameEngine
        self.gameControl = gameControl
    }

    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.preferredFramesPerSecond = Constants.framesPerSecond
        displayLink.add(to: .main, forMode: .default)

        gameControl.start()

        hasStarted = true
    }

    func stop() {
        guard hasStarted else {
            return
        }
        hasStarted = false

        gameControl.stop()

        displayLink.remove(from: .main, forMode: .default)
        displayLink.invalidate()
        displayLink = nil
    }

    func pause() {
        gameEngine.pause()
    }

    func unpause() {
        gameEngine.unpause()
    }

    @objc
    func step() {
        let elapsedTime = displayLink.targetTimestamp - displayLink.timestamp
        let inputForce = gameControl.getInputForce()

        gameEngine.update(deltaTime: CGFloat(elapsedTime), inputForce: inputForce)
        gameEngine.lateUpdate(deltaTime: CGFloat(elapsedTime))
    }
}
