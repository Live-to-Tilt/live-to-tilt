import Combine
import CoreMotion

class GyroViewModel: ObservableObject {
    @Published var x: Double
    @Published var y: Double

    var manager: CMMotionManager
    var timer: Timer?

    init() {
        x = 0
        y = 0
        manager = CMMotionManager()
        startAccelerometers()
    }

    deinit {
        stopAccelerometers()
    }

    func startAccelerometers() {
        guard manager.isAccelerometerAvailable else {
            x = 0
            y = 0
            return
        }

        manager.accelerometerUpdateInterval = 1.0 / 60.0
        manager.startAccelerometerUpdates()

        timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true) { _ in
            if let data = self.manager.accelerometerData {
                self.x = data.acceleration.x
                self.y = data.acceleration.y
            }
        }

        RunLoop.current.add(timer!, forMode: .default)
    }

    func stopAccelerometers() {
        guard timer != nil else {
            return
        }
        timer?.invalidate()
        timer = nil
        manager.stopAccelerometerUpdates()
    }
}
