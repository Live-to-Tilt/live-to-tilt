import CoreGraphics

final class RectangleCollider: Collider {
    var center: CGPoint
    var size: CGSize

    init(center: CGPoint, size: CGSize) {
        self.center = center
        self.size = size
    }

    func checkForCollision(with otherCollider: Collider) -> CollisionPoints {
        otherCollider.checkForCollision(with: self)
    }

    func checkForCollision(with otherCollider: CircleCollider) -> CollisionPoints {
        let otherPosition = otherCollider.center
        let normal = otherPosition - center
        let signX = CGVector(dx: normal.dx, dy: 0).unitVector.dx
        let signY = CGVector(dx: 0, dy: normal.dy).unitVector.dy
        let clampLengthX = min(size.width / 2, abs(normal.dx))
        let clampLengthY = min(size.height / 2, abs(normal.dy))
        let clampX = center.x + signX * clampLengthX
        let clampY = center.y + signY * clampLengthY
        let pointB = CGPoint(x: clampX, y: clampY)
        let radiusToPointB = pointB - otherPosition
        let pointA = otherPosition + radiusToPointB.unitVector * otherCollider.radius
        let hasCollision = (pointB - otherPosition).magnitude < otherCollider.radius
        return CollisionPoints(hasCollision: hasCollision, pointA: pointA, pointB: pointB)
    }

    func checkForCollision(with otherCollider: RectangleCollider) -> CollisionPoints {
        CollisionPoints.noCollision
    }

    func checkForCollision(with otherCollider: TriangleCollider) -> CollisionPoints {
        for vertex in otherCollider.vertices {
            if vertex.x > center.x - size.width / 2 &&
                vertex.x < center.x + size.width / 2 &&
                vertex.y > center.y - size.height / 2 &&
                vertex.y < center.y + size.height / 2 {
                return CollisionPoints.collision
            }
        }

        return CollisionPoints.noCollision
    }
}
