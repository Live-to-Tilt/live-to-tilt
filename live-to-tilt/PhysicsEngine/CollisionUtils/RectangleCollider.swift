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

    func checkCollision(with otherCollider: CircleCollider) -> CollisionPoints {
        let collisionPoints = otherCollider.checkCollision(with: self)

        return CollisionPoints(hasCollision: collisionPoints.hasCollision,
                               pointA: collisionPoints.pointB,
                               pointB: collisionPoints.pointA)
    }

    func checkCollision(with otherCollider: RectangleCollider) -> CollisionPoints {
        CollisionPoints.noCollision
    }
}
