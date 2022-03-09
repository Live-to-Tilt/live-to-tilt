import CoreGraphics
import Combine
import SpriteKit

final class PhysicsWorld {

    var contactDelegate: PhysicsContactDelegate?

    func updatePhysicsBodies(_ physicsBodies: [PhysicsBody], deltaTime: CGFloat) {
        for physicsBody in physicsBodies {
            physicsBody.update(deltaTime: deltaTime)
        }
    }

    func detectCollisions(for physicsBodies: [PhysicsBody]) -> [Collision] {
        let physicsBodies = physicsBodies.filter({ $0.isCollidable })

        var collisions: [Collision] = []

        for i in 0..<physicsBodies.count - 1 {
            let bodyA = physicsBodies[i]
            let colliderA = bodyA.collider
            for j in i + 1..<physicsBodies.count {
                let bodyB = physicsBodies[j]
                let colliderB = bodyB.collider
                let points = colliderA.checkForCollision(with: colliderB)

                if points.hasCollision {
                    collisions.append(Collision(bodyA: bodyA, bodyB: bodyB, collisionPoints: points))
                }
            }
        }

        return collisions
    }

//    private func resolveCollisions(for physicsBodies: [PhysicsBody]) {
//        let collisions = detectCollisions(for: physicsBodies)
//
//        collisions.forEach { collision in
//            let collisionPoints = collision.collisionPoints
//            let physicsBodyA = collision.bodyA
//
//            // Resolve position
//            physicsBodyA.position += collisionPoints.normalA * collisionPoints.depth
//
//            // Resolve velocity
//            let velocityDotNormal = physicsBodyA.velocity.dot(collisionPoints.normalA)
//            let velocityAlongNormal = collisionPoints.normalA * abs(velocityDotNormal)
//
//            physicsBodyA.velocity += velocityAlongNormal * 2
//
//            // Reduce velocity (bounce)
//            physicsBodyA.velocity *= (1 - physicsBodyA.restitution)
//        }
//    }

}
