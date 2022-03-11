import CoreMotion

class AccelerometerControl: GameControl {
    private var motion: CMMotionManager

    init() {
        motion = CMMotionManager()
    }

    func start() {
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = Constants.accelerometerUpdateInterval
            motion.startAccelerometerUpdates()
        }
    }

    func stop() {
        if motion.isAccelerometerActive {
            motion.stopAccelerometerUpdates()
        }
    }

    func getAcceleration() -> LTAcceleration {
        guard let data = motion.accelerometerData else {
            return LTAcceleration.zero
        }
        return LTAcceleration(from: data.acceleration)
    }
}
