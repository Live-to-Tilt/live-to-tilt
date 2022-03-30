import CoreGraphics

class EnemySystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let enemyComponents = nexus.getComponents(of: EnemyComponent.self)

        enemyComponents.forEach { enemyComponent in
            updateElapsedDuration(enemyComponent, deltaTime: deltaTime)

            if isLifespanOver(enemyComponent) {
                despawn(enemyComponent)
                return
            }

            handleCollisions(enemyComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updateElapsedDuration(_ enemyComponent: EnemyComponent, deltaTime: CGFloat) {
        enemyComponent.elapsedDuration += deltaTime
    }

    private func isLifespanOver(_ enemyComponent: EnemyComponent) -> Bool {
        enemyComponent.elapsedDuration > Constants.enemyLifespan
    }

    private func despawn(_ enemyComponent: EnemyComponent) {
        nexus.removeEntity(enemyComponent.entity)
    }

    private func handleCollisions(_ enemyComponent: EnemyComponent) {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: enemyComponent.entity)

        collisionComponents.forEach { collisionComponent in
            handlePowerupCollision(enemyComponent, collisionComponent)
        }
    }

    private func handlePowerupCollision(_ enemyComponent: EnemyComponent, _ collisionComponent: CollisionComponent) {
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
