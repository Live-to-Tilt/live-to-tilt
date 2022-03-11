import CoreGraphics

struct CollisionPoints {
    let hasCollision: Bool
    let pointA: CGPoint // Furthest point of A into B
    let pointB: CGPoint // Furthest point of B into A
    var normal: CGVector {
        (pointB - pointA).unitVector
    }
    var depth: CGFloat {
        (pointB - pointA).magnitude
    }

    static var noCollision: CollisionPoints {
        CollisionPoints(hasCollision: false, pointA: .zero, pointB: .zero)
    }

    static var collision: CollisionPoints {
        CollisionPoints(hasCollision: true, pointA: .zero, pointB: .zero)
    }
}

extension CollisionPoints: Hashable {
    static func == (lhs: CollisionPoints, rhs: CollisionPoints) -> Bool {
        return lhs.hasCollision == rhs.hasCollision
        && lhs.pointA == rhs.pointA
        && lhs.pointB == rhs.pointB
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hasCollision)
        hasher.combine(self.pointA.x)
        hasher.combine(self.pointA.y)
        hasher.combine(self.pointB.x)
        hasher.combine(self.pointB.y)
    }
}
