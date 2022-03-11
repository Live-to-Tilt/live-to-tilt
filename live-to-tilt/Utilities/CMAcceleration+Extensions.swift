import CoreGraphics
import CoreMotion

extension CMAcceleration {
    func toCGVector() -> CGVector {
        CGVector(dx: self.x, dy: self.y)
    }
}
