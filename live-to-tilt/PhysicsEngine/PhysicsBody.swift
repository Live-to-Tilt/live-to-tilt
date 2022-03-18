import CoreGraphics

final class PhysicsBody {
    static let minimumSize: CGFloat = PhysicsConstants.physicsBodyMinimumSize

    // Physical properties
    var mass: CGFloat
    var rotation: Double
    var shape: Shape
    var size: CGSize
    var velocity: CGVector
    var restitution: CGFloat
    var position: CGPoint

    // Force related properties
    var drag: CGFloat
    var isTrigger: Bool
    var isDynamic: Bool
    var forces: [CGVector]
    var netForce: CGVector {
        forces.reduce(CGVector.zero, +)
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
         shape: Shape,
         position: CGPoint,
         size: CGSize,
         rotation: CGFloat = .zero,
         mass: CGFloat = 1,
         velocity: CGVector = .zero,
         forces: [CGVector] = [],
         restitution: CGFloat = PhysicsConstants.restitution,
         drag: CGFloat = PhysicsConstants.drag,
         isTrigger: Bool = false) {
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
        self.isTrigger = isTrigger
    }

    func applyForce(_ force: CGVector) {
        forces.append(force)
    }

    func update(deltaTime: CGFloat) {
        let maxSpeed = PhysicsConstants.maxSpeed
        velocity += netForce / mass * deltaTime
        if velocity.magnitude > maxSpeed {
            velocity = velocity.unitVector * maxSpeed
        }

        let vector = velocity * deltaTime
        position += vector

        forces = []
    }

}

extension PhysicsBody: Hashable {
    static func == (lhs: PhysicsBody, rhs: PhysicsBody) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
