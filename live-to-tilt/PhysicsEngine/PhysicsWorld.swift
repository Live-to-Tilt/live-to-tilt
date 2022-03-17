import CoreGraphics

final class PhysicsWorld {

    weak var contactDelegate: PhysicsCollisionDelegate?
    var existingCollisions: Set<Collision>

    init() {
        existingCollisions = []
    }

    func update(_ physicsBodies: [PhysicsBody], deltaTime: CGFloat) {
        updatePhysicsBodies(physicsBodies, deltaTime: deltaTime)
        resolveCollisions(for: physicsBodies, deltaTime: deltaTime)
    }

    private func updatePhysicsBodies(_ physicsBodies: [PhysicsBody],
                                     deltaTime: CGFloat) {
        for physicsBody in physicsBodies {
            physicsBody.update(deltaTime: deltaTime)
        }
    }

    private func detectCollisions(for physicsBodies: [PhysicsBody]) -> Set<Collision> {
        var currentCollisions: Set<Collision> = []

        guard physicsBodies.count >= 2 else {
            existingCollisions = []
            return currentCollisions
        }

        for i in 0..<physicsBodies.count - 1 {
            let bodyA = physicsBodies[i]
            for j in (i + 1)..<physicsBodies.count {
                let bodyB = physicsBodies[j]
                let points = bodyA.collider.checkCollision(with: bodyB.collider)

                guard points.hasCollision else {
                    continue
                }

                let collision = Collision(bodyA: bodyA, bodyB: bodyB, collisionPoints: points)
                currentCollisions.insert(collision)

                if !existingCollisions.contains(collision) {
                    contactDelegate?.didBegin(collision)
                }
            }
        }

        // remove collisions that have ended
        for collision in existingCollisions.subtracting(currentCollisions) {
            contactDelegate?.didEnd(collision)
        }
        existingCollisions = currentCollisions

        return currentCollisions
    }

    private func resolveCollisions(for physicsBodies: [PhysicsBody], deltaTime: CGFloat) {
        let collisions = detectCollisions(for: physicsBodies)

        for collision in collisions {
            guard [collision.bodyA, collision.bodyB].allSatisfy({ $0.isTrigger == false }) else {
                continue
            }
            let collisionPoints = collision.collisionPoints
            let bodyA = collision.bodyA
            let bodyB = collision.bodyB

            // only handle dynamic-static collision
            if bodyA.isDynamic && !bodyB.isDynamic {
                resolveCollision(dynamicBody: bodyA,
                                 staticBody: bodyB,
                                 normal: collisionPoints.normal,
                                 depth: collisionPoints.depth,
                                 deltaTime: deltaTime)
            } else if bodyB.isDynamic && !bodyA.isDynamic {
                resolveCollision(dynamicBody: bodyB,
                                 staticBody: bodyA,
                                 normal: -collisionPoints.normal,
                                 depth: collisionPoints.depth,
                                 deltaTime: deltaTime)
            }
        }
    }

    private func resolveCollision(dynamicBody: PhysicsBody,
                                  staticBody: PhysicsBody,
                                  normal: CGVector,
                                  depth: CGFloat,
                                  deltaTime: CGFloat) {
        // Decouple physics bodies
        dynamicBody.position += normal * depth

        // Resolve velocity
        let velocity = dynamicBody.velocity
        let angle = normal.angle

        dynamicBody.velocity = CGVector(
            dx: -velocity.dx * cos(2 * angle) - velocity.dy * sin(2 * angle),
            dy: -velocity.dx * sin(2 * angle) + velocity.dy * cos(2 * angle)
        ) * (1 - dynamicBody.restitution)
    }
}
