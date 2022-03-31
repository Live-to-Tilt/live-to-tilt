import CoreGraphics

extension CGVector {
    static func == (lhs: CGVector, rhs: CGVector) -> Bool {
        lhs.dx == rhs.dx && lhs.dy == rhs.dy
    }

    static func += (lhs: inout CGVector, rhs: CGVector) {
        lhs = CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    static prefix func - (vector: CGVector) -> CGVector {
        let dx = -vector.dx == 0 ? 0 : -vector.dx
        let dy = -vector.dy == 0 ? 0 : -vector.dy
        return CGVector(dx: dx, dy: dy)
    }

    static func -= (lhs: inout CGVector, rhs: CGVector) {
        lhs = CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    static func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
        let xProduct = lhs.dx * rhs
        let yProduct = lhs.dy * rhs
        return CGVector(dx: xProduct == 0 ? 0 : xProduct, dy: yProduct == 0 ? 0 : yProduct)
    }

    static func * (lhs: CGFloat, rhs: CGVector) -> CGVector {
        let xProduct = lhs * rhs.dx
        let yProduct = lhs * rhs.dy
        return CGVector(dx: xProduct == 0 ? 0 : xProduct, dy: yProduct == 0 ? 0 : yProduct)
    }

    static func * (lhs: CGVector, rhs: CGVector) -> CGFloat {
        lhs.dx * rhs.dx + lhs.dy * rhs.dy
    }

    static func *= (lhs: inout CGVector, rhs: CGFloat) {
        lhs = CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    static func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
        CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }

    static func crossProduct(lhs: CGVector, rhs: CGVector) -> CGFloat {
        lhs.dx * rhs.dy - lhs.dy * rhs.dx
    }

    static func random(magnitude: CGFloat) -> CGVector {
        let randomX = CGFloat.random(in: -1...1)
        let randomY = CGFloat.random(in: -1...1)
        let randomVector = CGVector(dx: randomX, dy: randomY)
        return randomVector.unitVector * magnitude
    }

    static var up: CGVector {
        CGVector(dx: 0, dy: -1)
    }

    static var down: CGVector {
        CGVector(dx: 0, dy: 1)
    }

    static var left: CGVector {
        CGVector(dx: -1, dy: 0)
    }

    static var right: CGVector {
        CGVector(dx: 1, dy: 0)
    }

    var perpendicularAntiClockwise: CGVector {
        let x = -dx == 0 ? 0 : -dx
        return CGVector(dx: dy, dy: x)
    }

    var perpendicularClockwise: CGVector {
        let y = -dy == 0 ? 0 : -dy
        return CGVector(dx: y, dy: dx)
    }

    var magnitude: CGFloat {
        (dx.square() + dy.square()).squareRoot()
    }

    var magnitudeSquared: CGFloat {
        dx.square() + dy.square()
    }

    var unitVector: CGVector {
        let len = self.magnitude
        return len > 0 ? self / len : .zero
    }

    var angle: CGFloat {
        atan2(dy, dx)
    }

    func isRight(of vector: CGVector) -> Bool {
        let dot = vector.dx * -dy + vector.dy * dx
        return dot < 0
    }

    func dot(_ vector: CGVector) -> CGFloat {
        dx * vector.dx + dy * vector.dy
    }

}
