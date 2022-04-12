import CoreGraphics

final class EnemyKillerSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let enemyKillerComponents = nexus.getComponents(of: EnemyKillerComponent.self)

        enemyKillerComponents.forEach { enemyKillerComponent in
            handleCollisions(enemyKillerComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func handleCollisions(_ enemyKillerComponent: EnemyKillerComponent) {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: enemyKillerComponent.entity)

        collisionComponents.forEach { collisionComponent in
            handleEnemyCollision(enemyKillerComponent, collisionComponent)
        }
    }

    private func handleEnemyCollision(_ enemyKillerComponent: EnemyKillerComponent,
                                      _ collisionComponent: CollisionComponent) {
        let collidedEntity = collisionComponent.collidedEntity
        if !nexus.hasComponent(EnemyComponent.self, in: collidedEntity) {
            return
        }

        EventManager.shared.postEvent(EnemyKilledEvent())
        if let soundEffect = enemyKillerComponent.soundEffect {
            AudioController.shared.play(soundEffect)
        }
        nexus.removeEntity(collidedEntity)
    }
}
