import CoreGraphics
import CoreMotion

class AccelerometerControl: GameControl {
    private var motion: CMMotionManager

    init() {
        motion = CMMotionManager()
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

        var force = data.acceleration.toCGVector()
        force.dx *= 2
        force.dx *= 2
        force.dx = force.dx >= 0 ? max(1.0, force.dx) : min(-1.0, force.dx)
        force.dy = force.dy >= 0 ? max(1.0, force.dy) : min(-1.0, force.dy)

        return force
    }
}
