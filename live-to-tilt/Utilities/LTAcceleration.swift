import CoreMotion

struct LTAcceleration {
    var x: Double
    var y: Double

    static var zero: LTAcceleration {
        LTAcceleration(x: 0, y: 0)
    }

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    init(from acceleration: CMAcceleration) {
        self.x = acceleration.x
        self.y = acceleration.y
    }
}
