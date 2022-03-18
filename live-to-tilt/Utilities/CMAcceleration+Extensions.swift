import CoreGraphics
import CoreMotion

extension CMAcceleration {
    func toCGVector() -> CGVector {
        CGVector(dx: -self.y, dy: -self.x)
    }
}
