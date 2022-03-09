import CoreGraphics

struct CollisionPoints {
    let hasCollision: Bool
    let pointA: CGPoint
    let pointB: CGPoint

    let isVertexCollision: Bool
    let vertex: CGPoint
    let edgeA: CGVector
    let edgeB: CGVector
    let normalA: CGVector
    let normalB: CGVector
    let normalC: CGVector

    static var noCollision: CollisionPoints {
        CollisionPoints(hasCollision: false, pointA: .zero, pointB: .zero)
    }

    static var collision: CollisionPoints {
        CollisionPoints(hasCollision: true, pointA: .zero, pointB: .zero)
    }

    init(hasCollision: Bool, pointA: CGPoint, pointB: CGPoint) {
        self.hasCollision = hasCollision
        self.pointA = pointA
        self.pointB = pointB
        self.isVertexCollision = false
        self.vertex = .zero
        self.edgeA = .zero
        self.edgeB = .zero
        self.normalA = .zero
        self.normalB = .zero
        self.normalC = .zero
    }

    init(hasCollision: Bool,
         vertex: CGPoint,
         edgeA: CGVector,
         edgeB: CGVector,
         normalA: CGVector,
         normalB: CGVector,
         normalC: CGVector) {
        self.hasCollision = hasCollision
        self.pointA = .zero
        self.pointB = .zero
        self.isVertexCollision = true
        self.vertex = vertex
        self.edgeA = edgeA
        self.edgeB = edgeB
        self.normalA = normalA
        self.normalB = normalB
        self.normalC = normalC
    }
}
