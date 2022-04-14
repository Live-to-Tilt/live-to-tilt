import QuartzCore

class MultiplayerHostGameRenderer: GameRenderer {
    private let gameEngine: GameEngine
    private var gameControl: GameControl
    private var displayLink: CADisplayLink!
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

    }

    func pause() {

    }

    func unpause() {

    }

    @objc
    func step() {
        let elapsedTime = displayLink.targetTimestamp - displayLink.timestamp
        let inputForce = gameControl.getInputForce()

        gameEngine.update(deltaTime: CGFloat(elapsedTime), inputForce: inputForce)
        gameEngine.lateUpdate(deltaTime: CGFloat(elapsedTime))
    }
}
