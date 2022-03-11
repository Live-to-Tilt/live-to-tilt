import QuartzCore
import CoreMotion

class GameRenderer {
    private let gameEngine: GameEngine
    private var displayLink: CADisplayLink!
    private var motion: CMMotionManager!
    private var hasStarted = false

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
    }

    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.preferredFramesPerSecond = Constants.framesPerSecond
        displayLink.add(to: .main, forMode: .default)

        motion = CMMotionManager()
        motion.accelerometerUpdateInterval = 1.0 / 60.0
        motion.startAccelerometerUpdates()

        hasStarted = true
    }

    func stop() {
        guard hasStarted else {
            return
        }
        hasStarted = false

        motion.stopAccelerometerUpdates()
        motion = nil

        displayLink.invalidate()
        displayLink.remove(from: .main, forMode: .default)
        displayLink = nil
    }

    @objc
    func step() {
        let elapsedTime = displayLink.targetTimestamp - displayLink.timestamp
        var acceleration = LTAcceleration.zero
        if let data = motion.accelerometerData {
            acceleration = LTAcceleration(from: data.acceleration)
        }

        gameEngine.update(deltaTime: CGFloat(elapsedTime), acceleration: acceleration)
    }
}
