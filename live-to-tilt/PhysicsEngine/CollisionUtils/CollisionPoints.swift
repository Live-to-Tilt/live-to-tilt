import CoreGraphics

struct CollisionPoints {
    let hasCollision: Bool
    let pointA: CGPoint // Furthest point of A into B
    let pointB: CGPoint // Furthest point of B into A
    var normal: CGVector
    var depth: CGFloat

    init(hasCollision: Bool,
         pointA: CGPoint,
         pointB: CGPoint) {
        self.hasCollision = hasCollision
        self.pointA = pointA
        self.pointB = pointB
        self.normal = (pointB - pointA).unitVector
        self.depth = (pointB - pointA).magnitude
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
        lhs.hasCollision == rhs.hasCollision
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
