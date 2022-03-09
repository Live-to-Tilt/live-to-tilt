import CoreGraphics

final class PhysicsUtils {
    static func findProjection(from point: CGPoint, toLine direction: CGVector, pointOnLine: CGPoint) -> CGPoint {
        let unitVector = point - pointOnLine
        let projectionVector = ((unitVector * direction) / direction.magnitudeSquared) * direction
        let projection = pointOnLine + projectionVector
        return projection
    }

    static func findAngleBetween(vector1: CGVector, vector2: CGVector) -> CGFloat {
        let cosAngle = (vector1 * vector2) / (vector1.magnitude * vector2.magnitude)
        let angle = acos(cosAngle)
        return angle
    }

    static func rotateVectorClockwise(vector: CGVector, by angle: CGFloat) -> CGVector {
        let newX = vector.dx * cos(angle) - vector.dy * sin(angle)
        let newY = vector.dx * sin(angle) + vector.dy * cos(angle)

        return CGVector(dx: newX, dy: newY)
    }

    static func isVectorBetween(middle vectorC: CGVector, left vectorA: CGVector, right vectorB: CGVector) -> Bool {
        let sign1 = CGVector.crossProduct(lhs: vectorA, rhs: vectorC).sign
        let sign2 = CGVector.crossProduct(lhs: vectorC, rhs: vectorB).sign
        return sign1 == sign2
    }

    static func rotate(point: CGPoint, around pivot: CGPoint, angle: Double) -> CGPoint {
        let sin = CGFloat(sin(angle))
        let cos = CGFloat(cos(angle))

        let translatedPoint = CGPoint(x: point.x - pivot.x, y: point.y - pivot.y)
        let rotatedTranslatedPoint = CGPoint(x: translatedPoint.x * cos - translatedPoint.y * sin,
                                             y: translatedPoint.x * sin + translatedPoint.y * cos)
        let rotatedPoint = CGPoint(x: rotatedTranslatedPoint.x + pivot.x, y: rotatedTranslatedPoint.y + pivot.y)

        return rotatedPoint
    }

    static func isLeft(linePointA: CGPoint, linePointB: CGPoint, point: CGPoint) -> Bool {
        (linePointB.x - linePointA.x) * (point.y - linePointA.y) -
            (linePointB.y - linePointA.y) * (point.x - linePointA.x) > 0
    }

    static func findCentroid(vertices: [CGPoint]) -> CGPoint {
        let averageX = vertices.map({ $0.x }).reduce(0, +) / 3
        let averageY = vertices.map({ $0.y }).reduce(0, +) / 3
        return CGPoint(x: averageX, y: averageY)
    }

    static func findCenter(vertices: [CGPoint]) -> CGPoint {
        if vertices.isEmpty {
            return .zero
        }

        var lowestX: CGFloat = vertices[0].x
        var highestX: CGFloat = vertices[0].x
        var lowestY: CGFloat = vertices[0].y
        var highestY: CGFloat = vertices[0].y
        for vertex in vertices {
            lowestX = min(lowestX, vertex.x)
            highestX = max(highestX, vertex.x)
            lowestY = min(lowestY, vertex.y)
            highestY = max(highestY, vertex.y)
        }
        return CGPoint(x: (lowestX + highestX) / 2, y: (lowestY + highestY) / 2)
    }

    static func scaleVertices(vertices: [CGPoint], scale: CGFloat, position: CGPoint) -> [CGPoint] {
        let averageX = vertices.map({ $0.x }).reduce(0, +) / 3
        let averageY = vertices.map({ $0.y }).reduce(0, +) / 3
        let centroid = CGPoint(x: averageX, y: averageY)
        let scaledVertices = vertices.map({ scaleVertex(vertex: $0, centroid: centroid, scale: scale) })
        let center = PhysicsUtils.findCenter(vertices: scaledVertices)
        let vector = position - center
        let compensatedVertices = scaledVertices.map({ $0 + vector })
        return compensatedVertices
    }

    static func scaleVertex(vertex: CGPoint, centroid: CGPoint, scale: CGFloat) -> CGPoint {
        let vector = vertex - centroid
        let scaledVector = scale * vector
        let newVertex = centroid + scaledVector
        return newVertex
    }

    static func rotateAroundPoint(_ point: CGPoint, by angle: CGFloat) -> CGAffineTransform {
        let translatePointToOrigin = CGAffineTransform(translationX: point.x, y: point.y)
        let rotate = CGAffineTransform(rotationAngle: angle)

        return translatePointToOrigin.inverted()
            .concatenating(rotate)
            .concatenating(translatePointToOrigin)
    }
}
