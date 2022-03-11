import CoreGraphics
import Combine
import SpriteKit

final class PhysicsWorld {

    var contactDelegate: PhysicsContactDelegate?
    var existingCollisions: Set<Collision>

    init() {
        existingCollisions = []
    }

    func updatePhysicsBodies(_ physicsBodies: [PhysicsBody], deltaTime: CGFloat) {
        for physicsBody in physicsBodies {
            physicsBody.update(deltaTime: deltaTime)
        }
        resolveCollisions(for: physicsBodies, deltaTime: deltaTime)
    }

    private func detectCollisions(for physicsBodies: [PhysicsBody]) -> Set<Collision> {
        let physicsBodies = physicsBodies.filter({ $0.isCollidable })

        var currentCollisions: Set<Collision> = []

        for i in 0..<physicsBodies.count - 1 {
            let bodyA = physicsBodies[i]
            let colliderA = bodyA.collider
            for j in i + 1..<physicsBodies.count {
                let bodyB = physicsBodies[j]
                let colliderB = bodyB.collider
                let points = colliderA.checkCollision(with: colliderB)

                guard points.hasCollision else {
                    continue
                }

                let collision: Collision = Collision(bodyA: bodyA, bodyB: bodyB, collisionPoints: points)
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
            guard [collision.bodyA, collision.bodyB].allSatisfy({ $0.isCollidable == true }) else {
                continue
            }
            let collisionPoints = collision.collisionPoints
            let bodyA = collision.bodyA
            let bodyB = collision.bodyB

            if bodyA.isDynamic && bodyB.isDynamic {
                resolveCollision(dynamicBodyA: bodyA, dynamicBodyB: bodyB, pointA: collisionPoints.pointA, pointB: collisionPoints.pointB, deltaTime: deltaTime)
            } else if bodyA.isDynamic {
                resolveCollision(dynamicBody: bodyA, staticBody: bodyB, normal: collisionPoints.normal, depth: collisionPoints.depth, deltaTime: deltaTime)
            } else if bodyB.isDynamic {
                resolveCollision(dynamicBody: bodyB, staticBody: bodyA, normal: -collisionPoints.normal, depth: collisionPoints.depth, deltaTime: deltaTime)
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
    }

    private func resolveCollision(dynamicBodyA: PhysicsBody,
                                  dynamicBodyB: PhysicsBody,
                                  pointA: CGPoint,
                                  pointB: CGPoint,
                                  deltaTime: CGFloat) {
        // Decouple physics bodies
        let normalA = pointB - pointA // normal used to resolve bodyA
        let normalB = pointA - pointB // normal used to resolve bodyB

        let oldPositionA = dynamicBodyA.position
        let oldPositionB = dynamicBodyB.position
        dynamicBodyA.position = oldPositionA + normalA / 2
        dynamicBodyB.position = oldPositionB + normalB / 2
    }

}
