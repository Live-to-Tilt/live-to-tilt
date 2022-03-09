import CoreGraphics

final class CircleCollider: Collider {
    var center: CGPoint
    var radius: CGFloat

    init(center: CGPoint, radius: CGFloat) {
        self.center = center
        self.radius = radius
    }

    func checkForCollision(with otherCollider: Collider) -> CollisionPoints {
        otherCollider.checkForCollision(with: self)
    }

    func checkForCollision(with otherCollider: CircleCollider) -> CollisionPoints {
        let otherPosition = otherCollider.center
        let normal = otherPosition - center
        let pointA = otherPosition - normal.unitVector * otherCollider.radius
        let pointB = center + normal.unitVector * radius
        let hasCollision = normal.magnitude < radius + otherCollider.radius
        return CollisionPoints(hasCollision: hasCollision, pointA: pointA, pointB: pointB)
    }

    func checkForCollision(with otherCollider: RectangleCollider) -> CollisionPoints {
        let otherPosition = otherCollider.center
        let normal = center - otherPosition
        let signX = CGVector(dx: normal.dx, dy: 0).unitVector.dx
        let signY = CGVector(dx: 0, dy: normal.dy).unitVector.dy
        let clampLengthX = min(otherCollider.size.width / 2, abs(normal.dx))
        let clampLengthY = min(otherCollider.size.height / 2, abs(normal.dy))
        let clampX = otherPosition.x + signX * clampLengthX
        let clampY = otherPosition.y + signY * clampLengthY
        let pointA = CGPoint(x: clampX, y: clampY)
        let radiusToPointA = pointA - center
        let pointB = center + radiusToPointA.unitVector * radius
        let hasCollision = (pointA - center).magnitude < radius
        return CollisionPoints(hasCollision: hasCollision, pointA: pointA, pointB: pointB)
    }

    func checkForCollision(with otherCollider: TriangleCollider) -> CollisionPoints {
        if isInside(otherCollider: otherCollider) {
            return CollisionPoints.collision
        }

        for i in 0..<otherCollider.vertices.count {
            let vertex = otherCollider.vertices[i]
            let vertexCenterDistance = (vertex - center).magnitude
            if vertexCenterDistance < radius {
                return calculateVertexCollisionPoints(with: otherCollider, vertexIndex: i)
            }
        }

        for i in 0..<otherCollider.vertices.count {
            let vertexA = otherCollider.vertices[i]
            let vertexB = otherCollider.vertices[(i + 1) % 3]
            let vertexAToVertexB = vertexB - vertexA
            let vertexAToCenter = center - vertexA
            let dot = vertexAToCenter * vertexAToVertexB
            if dot > 0 {
                let projection = PhysicsUtils.findProjection(from: center, toLine: vertexAToVertexB, pointOnLine: vertexA)
                let vertexAToProjectionDistance = (projection - vertexA).magnitude
                let edgeLength = vertexAToVertexB.magnitude

                if vertexAToProjectionDistance > edgeLength {
                    continue
                }

                let projectionToCenterDistance = (center - projection).magnitude
                if projectionToCenterDistance < radius {
                    return calculateEdgeCollisionPoints(projection: projection, center: center, radius: radius)
                }
            }
        }

        return CollisionPoints.noCollision
    }

    private func calculateVertexCollisionPoints(with otherCollider: TriangleCollider,
                                                vertexIndex: Int) -> CollisionPoints {
        let vertex = otherCollider.vertices[vertexIndex]
        let vertexA = otherCollider.vertices[(vertexIndex + 1) % 3]
        let vertexB = otherCollider.vertices[vertexIndex - 1 < 0 ? 2 : vertexIndex - 1]
        let edgeA = vertexA - vertex
        let edgeB = vertexB - vertex
        let projectionA = PhysicsUtils.findProjection(from: center, toLine: edgeA, pointOnLine: vertexA)
        let magnitudeA = radius - (center - projectionA).magnitude
        let normalA = edgeA.perpendicularAntiClockwise.unitVector * magnitudeA
        let projectionB = PhysicsUtils.findProjection(from: center, toLine: edgeB, pointOnLine: vertexB)
        let magnitudeB = radius - (center - projectionB).magnitude
        let normalB = edgeB.perpendicularClockwise.unitVector * magnitudeB
        let centroid = PhysicsUtils.findCentroid(vertices: otherCollider.vertices)
        let radius = (centroid - vertex).magnitude
        let circleC = CircleCollider(center: centroid, radius: radius)
        let collisionPoints = circleC.checkForCollision(with: self)
        let normalC = collisionPoints.pointB - collisionPoints.pointA
        return CollisionPoints(hasCollision: true,
                               vertex: vertex,
                               edgeA: edgeA,
                               edgeB: edgeB,
                               normalA: normalA,
                               normalB: normalB,
                               normalC: normalC)
    }

    private func calculateEdgeCollisionPoints(projection: CGPoint,
                                              center: CGPoint,
                                              radius: CGFloat) -> CollisionPoints {
        let pointA = projection
        let centerToProjection = projection - center
        let pointB = center + centerToProjection.unitVector * radius
        return CollisionPoints(hasCollision: true, pointA: pointA, pointB: pointB)
    }

    private func isInside(otherCollider: TriangleCollider) -> Bool {
        var flags: [Bool] = []
        for i in 0..<otherCollider.vertices.count {
            let vertexA = otherCollider.vertices[i]
            let vertexB = otherCollider.vertices[(i + 1) % 3]
            let vector = vertexB - vertexA
            flags.append(center.isLeft(of: vector, vertexA))
        }

        var isInsideTriangle = true
        for i in 0..<otherCollider.vertices.count {
            let flagA = flags[i]
            let flagB = flags[(i + 1) % 3]
            if flagA != flagB {
                isInsideTriangle = false
                break
            }
        }

        return isInsideTriangle
    }

    private func calculateLineCollisionPoints(topPoint: CGPoint,
                                              bottomPoint: CGPoint) -> CollisionPoints {
        let line = bottomPoint - topPoint
        let projection = PhysicsUtils.findProjection(from: center, toLine: line, pointOnLine: topPoint)
        let magnitude = radius - (center - projection).magnitude
        let normalA = line.perpendicularClockwise.unitVector * magnitude // circle collides from left
        let normalB = line.perpendicularAntiClockwise.unitVector * magnitude // circle collides from right

        let topPointToCenterDistance = (topPoint - center).magnitude
        let bottomPointToCenterDistance = (bottomPoint - center).magnitude

        if topPointToCenterDistance < radius { // top vertex collision
            let center = CGPoint(x: topPoint.x, y: topPoint.y + radius)
            let circleC = CircleCollider(center: center, radius: radius)
            let collisionPoints = circleC.checkForCollision(with: self)
            let normalC = collisionPoints.pointB - collisionPoints.pointA
            return CollisionPoints(hasCollision: true,
                                   vertex: topPoint,
                                   edgeA: line,
                                   edgeB: line,
                                   normalA: normalA,
                                   normalB: normalB,
                                   normalC: normalC)
        }

        if bottomPointToCenterDistance < radius { // bottom vertext collision
            let center = CGPoint(x: bottomPoint.x, y: bottomPoint.y - radius)
            let circleC = CircleCollider(center: center, radius: radius)
            let collisionPoints = circleC.checkForCollision(with: self)
            let normalC = collisionPoints.pointB - collisionPoints.pointA
            return CollisionPoints(hasCollision: true,
                                   vertex: bottomPoint,
                                   edgeA: line,
                                   edgeB: line,
                                   normalA: normalA,
                                   normalB: normalB,
                                   normalC: normalC)
        }

        if PhysicsUtils.isLeft(linePointA: topPoint, linePointB: bottomPoint, point: center) {
            let pointA = projection
            let pointB = projection - normalA
            return CollisionPoints(hasCollision: true, pointA: pointA, pointB: pointB)
        } else {
            let pointA = projection
            let pointB = projection - normalB
            return CollisionPoints(hasCollision: true, pointA: pointA, pointB: pointB)
        }
    }
}
