import CoreGraphics

class EnemySystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let enemyComponents = nexus.getComponents(of: EnemyComponent.self)

        enemyComponents.forEach { enemyComponent in
            handleCollisions(enemyComponent)
        }
    }

    func handleCollisions(_ enemyComponent: EnemyComponent) {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: enemyComponent.entity)

        collisionComponents.forEach { collisionComponent in
            handlePowerupCollision(enemyComponent, collisionComponent)
        }

        nexus.removeComponents(of: CollisionComponent.self, for: enemyComponent.entity)
    }

    func handlePowerupCollision(_ enemyComponent: EnemyComponent, _ collisionComponent: CollisionComponent) {
        guard
            let powerupComponent = nexus.getComponent(of: PowerupComponent.self,
                                                      for: collisionComponent.collidedEntity),
            powerupComponent.isActive,
            powerupComponent.effect is NukeEffect
        else {
            return
        }

        nexus.removeEntity(enemyComponent.entity)
    }
}
