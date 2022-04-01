import CoreGraphics

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }

    static func += (lhs: inout CGPoint, rhs: CGVector) {
        lhs = CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }

    static func - (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }

    func normalize(frame: CGRect) -> CGPoint {
        let transform = CGAffineTransform(scaleX: 1 / frame.maxY, y: 1 / frame.maxY)
        return self.applying(transform)
    }

    func denormalize(frame: CGRect) -> CGPoint {
        let transform = CGAffineTransform(scaleX: frame.maxY, y: frame.maxY)
        return self.applying(transform)
    }

    func denormalize(by value: CGFloat) -> CGPoint {
        let transform = CGAffineTransform(scaleX: value, y: value)
        return self.applying(transform)
    }

    func isLeft(of vector: CGVector, _ pointOnVector: CGPoint) -> Bool {
        let otherPoint = pointOnVector + vector
        let determinant = ((x - pointOnVector.x) * (otherPoint.y - pointOnVector.y)
                            - (y - pointOnVector.y) * (otherPoint.x - pointOnVector.x))
        return determinant > 0
    }

    func distanceTo(_ point: CGPoint) -> CGFloat {
        (self - point).magnitude
    }

    func rotated(around pivot: CGPoint, by angle: Double) -> CGPoint {
        let sin = CGFloat(sin(angle))
        let cos = CGFloat(cos(angle))

        let translatedPoint = CGPoint(x: self.x - pivot.x, y: self.y - pivot.y)
        let rotatedTranslatedPoint = CGPoint(x: translatedPoint.x * cos - translatedPoint.y * sin,
                                             y: translatedPoint.x * sin + translatedPoint.y * cos)
        let rotatedPoint = CGPoint(x: rotatedTranslatedPoint.x + pivot.x, y: rotatedTranslatedPoint.y + pivot.y)

        return rotatedPoint
    }
}
