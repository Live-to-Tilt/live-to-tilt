import CoreGraphics

final class TriangleCollider: Collider {
    var vertices: [CGPoint]
    var centroid: CGPoint {
        PhysicsUtils.findCentroid(vertices: vertices)
    }

    init(vertices: [CGPoint]) {
        self.vertices = vertices
    }

    func checkForCollision(with otherCollider: Collider) -> CollisionPoints {
        otherCollider.checkForCollision(with: self)
    }

    func checkForCollision(with otherCollider: CircleCollider) -> CollisionPoints {
        if contains(otherCollider: otherCollider) {
            return CollisionPoints.collision
        }

        for i in 0..<vertices.count {
            let vertex = vertices[i]
            let vertexCenterDistance = (vertex - otherCollider.center).magnitude
            if vertexCenterDistance < otherCollider.radius {
                return calculateVertexCollisionPoints(with: otherCollider, vertexIndex: i)
            }
        }

        for i in 0..<vertices.count {
            let vertexA = vertices[i]
            let vertexB = vertices[(i + 1) % 3]
            let vertexAToVertexB = vertexB - vertexA
            let vertexAToCenter = otherCollider.center - vertexA
            let dot = vertexAToCenter * vertexAToVertexB
            if dot > 0 {
                let projection = PhysicsUtils.findProjection(from: otherCollider.center,
                                                       toLine: vertexAToVertexB,
                                                       pointOnLine: vertexA)
                let vertexAToProjectionDistance = (projection - vertexA).magnitude
                let edgeLength = vertexAToVertexB.magnitude

                if vertexAToProjectionDistance > edgeLength {
                    continue
                }

                let projectionToCenterDistance = (otherCollider.center - projection).magnitude
                if projectionToCenterDistance < otherCollider.radius {
                    return calculateEdgeCollisionPoints(projection: projection,
                                                        center: otherCollider.center,
                                                        radius: otherCollider.radius)
                }
            }
        }

        return CollisionPoints.noCollision
    }

    func checkForCollision(with otherCollider: RectangleCollider) -> CollisionPoints {
        for vertex in vertices {
            if vertex.x > otherCollider.center.x - otherCollider.size.width / 2 &&
                vertex.x < otherCollider.center.x + otherCollider.size.width / 2 &&
                vertex.y > otherCollider.center.y - otherCollider.size.height / 2 &&
                vertex.y < otherCollider.center.y + otherCollider.size.height / 2 {
                return CollisionPoints.collision
            }
        }

        return CollisionPoints.noCollision
    }

    func checkForCollision(with otherCollider: TriangleCollider) -> CollisionPoints {
        if hasSeparatingEdge(in: self, against: otherCollider) || hasSeparatingEdge(in: otherCollider, against: self) {
            return CollisionPoints.noCollision
        }

        return CollisionPoints.collision
    }

    private func hasSeparatingEdge(in triangleColliderA: TriangleCollider,
                                   against triangleColliderB: TriangleCollider) -> Bool {
        for i in 0..<triangleColliderA.vertices.count {
            let vertexA = triangleColliderA.vertices[i]
            let vertexB = triangleColliderA.vertices[(i + 1) % 3]
            let vertexC = triangleColliderA.vertices[(i + 2) % 3]
            let flag = PhysicsUtils.isLeft(linePointA: vertexA, linePointB: vertexB, point: vertexC)
            var hasSeparatingEdge = true

            for j in 0..<triangleColliderB.vertices.count {
                let vertex = triangleColliderB.vertices[j]
                let toCheck = PhysicsUtils.isLeft(linePointA: vertexA, linePointB: vertexB, point: vertex)
                if flag == toCheck {
                    hasSeparatingEdge = false
                    break
                }
            }

            if hasSeparatingEdge {
                return true
            }
        }

        return false
    }

    private func calculateVertexCollisionPoints(with otherCollider: CircleCollider,
                                                vertexIndex: Int) -> CollisionPoints {
        let vertex = vertices[vertexIndex]
        let vertexA = vertices[(vertexIndex + 1) % 3]
        let vertexB = vertices[vertexIndex - 1 < 0 ? 2 : vertexIndex - 1]
        let edgeA = vertexA - vertex
        let edgeB = vertexB - vertex
        let projectionA = PhysicsUtils.findProjection(from: otherCollider.center, toLine: edgeA, pointOnLine: vertexA)
        let magnitudeA = otherCollider.radius - (otherCollider.center - projectionA).magnitude
        let normalA = edgeA.perpendicularAntiClockwise.unitVector * magnitudeA
        let projectionB = PhysicsUtils.findProjection(from: otherCollider.center, toLine: edgeB, pointOnLine: vertexB)
        let magnitudeB = otherCollider.radius - (otherCollider.center - projectionB).magnitude
        let normalB = edgeB.perpendicularClockwise.unitVector * magnitudeB
        let centroid = PhysicsUtils.findCentroid(vertices: vertices)
        let radius = (centroid - vertex).magnitude
        let circleC = CircleCollider(center: centroid, radius: radius)
        let collisionPoints = circleC.checkForCollision(with: otherCollider)
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
        let pointB = projection
        let centerToProjection = projection - center
        let pointA = center + centerToProjection.unitVector * radius
        return CollisionPoints(hasCollision: true, pointA: pointA, pointB: pointB)
    }

    private func contains(otherCollider: CircleCollider) -> Bool {
        var flags: [Bool] = []
        for i in 0..<vertices.count {
            let vertexA = vertices[i]
            let vertexB = vertices[(i + 1) % 3]
            let vector = vertexB - vertexA
            flags.append(otherCollider.center.isLeft(of: vector, vertexA))
        }

        var containsCircle = true
        for i in 0..<vertices.count {
            let flagA = flags[i]
            let flagB = flags[(i + 1) % 3]
            if flagA != flagB {
                containsCircle = false
                break
            }
        }

        return containsCircle
    }
}
