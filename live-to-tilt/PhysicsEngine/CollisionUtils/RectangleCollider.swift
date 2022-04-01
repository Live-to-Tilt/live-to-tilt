import CoreGraphics

final class RectangleCollider: Collider {
    var center: CGPoint
    var size: CGSize
    var rotation: Double

    init(center: CGPoint, size: CGSize, rotation: Double) {
        self.center = center
        self.size = size
        self.rotation = rotation
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
