import CoreGraphics

class CollisionSystem: System {
    let nexus: Nexus
    let physicsWorld: PhysicsWorld

    init(nexus: Nexus, physicsWorld: PhysicsWorld) {
        self.nexus = nexus
        self.physicsWorld = physicsWorld
        self.physicsWorld.collisionDelegate = self
    }

    func update(deltaTime: CGFloat) {}

    func lateUpdate(deltaTime: CGFloat) {
        nexus.removeComponents(of: CollisionComponent.self)
    }
}

// MARK: PhysicsCollisionDelegate
extension CollisionSystem: PhysicsCollisionDelegate {
    func didBegin(_ collision: Collision) {
        guard
            let entityA = getEntityFromPhysicsBody(collision.bodyA),
            let entityB = getEntityFromPhysicsBody(collision.bodyB)
        else {
            return
        }

        nexus.addComponent(CollisionComponent(entity: entityA, collidedEntity: entityB), to: entityA)
        nexus.addComponent(CollisionComponent(entity: entityB, collidedEntity: entityA), to: entityB)
    }

    func didEnd(_ collision: Collision) {
    }

    private func getEntityFromPhysicsBody(_ physicsBody: PhysicsBody) -> Entity? {
        let physicsComponents = nexus.getComponents(of: PhysicsComponent.self)
        let physicsComponent = physicsComponents.first(where: { $0.physicsBody === physicsBody })

        return physicsComponent?.entity
    }
}
