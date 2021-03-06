import CoreGraphics
import CoreMotion

class AccelerometerControl: GameControl {
    private var motion: CMMotionManager
    private let sensitivity: CGFloat

    init(sensitivity: Float) {
        self.motion = CMMotionManager()
        self.sensitivity = CGFloat(sensitivity)
    }

    func start() {
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 1.0 / Double(Constants.framesPerSecond)
            motion.startAccelerometerUpdates()
        }
    }

    func stop() {
        if motion.isAccelerometerActive {
            motion.stopAccelerometerUpdates()
        }
    }

    func getInputForce() -> CGVector {
        guard let data = motion.accelerometerData else {
            return CGVector.zero
        }

        return data.acceleration.toCGVector() * sensitivity
    }
}
