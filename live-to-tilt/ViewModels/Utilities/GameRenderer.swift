import QuartzCore

class GameRenderer {
    private let gameEngine: GameEngine
    private var displayLink: CADisplayLink!
    private var hasStarted = false

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
    }

    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.preferredFramesPerSecond = Constants.framesPerSecond
        displayLink.add(to: .main, forMode: .default)
        hasStarted = true
    }

    func stop() {
        guard hasStarted else {
            return
        }
        hasStarted = false
        displayLink.invalidate()
        displayLink.remove(from: .main, forMode: .default)
        displayLink = nil
    }

    @objc
    func step() {
        let elapsedTime = displayLink.targetTimestamp - displayLink.timestamp
        gameEngine.update(deltaTime: CGFloat(elapsedTime))
    }
}
