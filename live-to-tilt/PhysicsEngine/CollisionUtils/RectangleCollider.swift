import CoreGraphics

final class RectangleCollider: Collider {
    var center: CGPoint
    var size: CGSize

    init(center: CGPoint, size: CGSize) {
        self.center = center
        self.size = size
    }

    func checkCollision(with otherCollider: Collider) -> CollisionPoints {
        otherCollider.checkCollision(with: self)
    }

    // Rect-circle
    func checkCollision(with otherCollider: CircleCollider) -> CollisionPoints {
        let collisionPoints = otherCollider.checkCollision(with: self)

        return CollisionPoints(hasCollision: collisionPoints.hasCollision,
                               pointA: collisionPoints.pointB,
                               pointB: collisionPoints.pointA)
    }

    // Rect-rect (not supported)
    func checkCollision(with otherCollider: RectangleCollider) -> CollisionPoints {
        CollisionPoints.noCollision
    }
}
