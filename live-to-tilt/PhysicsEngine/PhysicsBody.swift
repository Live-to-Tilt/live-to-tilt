import CoreGraphics

final class PhysicsBody {
    static let minimumSize: CGFloat = Constants.physicsBodyMinimumSize

    // Physical Properties
    var mass: CGFloat
    var rotation: Double
    var shape: Shapes
    var size: CGSize
    var velocity: CGVector
    var restitution: CGFloat
    var position: CGPoint

    // Force related properties
    var drag: CGFloat
    var isCollidable: Bool // if false, can only detect contact, will not resolve collision
    var isDynamic: Bool
    var forces: [CGVector]
    var netForce: CGVector {
        var netForce = CGVector.zero
        forces.forEach { force in
            netForce += force
        }
        return netForce
    }

    var collider: Collider {
        switch shape {
        case .circle:
            return CircleCollider(center: position, radius: size.width / 2)
        case .rectangle:
            return RectangleCollider(center: position, size: size)
        }
    }

    init(isDynamic: Bool,
         shape: Shapes,
         position: CGPoint,
         size: CGSize,
         rotation: Double = 0,
         mass: CGFloat = 1,
         velocity: CGVector = .zero,
         forces: [CGVector] = [],
         restitution: CGFloat = Constants.restitution,
         drag: CGFloat = Constants.drag,
         isCollidable: Bool = false) {
        self.isDynamic = isDynamic
        self.shape = shape
        self.position = position
        self.size = size
        self.rotation = rotation
        self.mass = mass
        self.velocity = velocity
        self.forces = forces
        self.restitution = restitution
        self.drag = drag
        self.isCollidable = isCollidable
    }

    func applyForce(_ force: CGVector) {
        forces.append(force)
    }

    func update(deltaTime: CGFloat) {
        let maxVelocity = PhysicsBody.minimumSize / deltaTime
        velocity += netForce / mass * deltaTime
        if velocity.magnitude > maxVelocity {
            velocity = velocity.unitVector * maxVelocity
        }

        let vector = velocity * deltaTime
        position += vector

        // Reset forces
        forces = []
    }

    private func calculateRotatedVertices(_ vertices: [CGPoint]) -> [CGPoint] {
        vertices.map({ PhysicsUtils.rotate(point: $0, around: position, angle: rotation) })
    }
}

extension PhysicsBody: Hashable {
    static func == (lhs: PhysicsBody, rhs: PhysicsBody) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
