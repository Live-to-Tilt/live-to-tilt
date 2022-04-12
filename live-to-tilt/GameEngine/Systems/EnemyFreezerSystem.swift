import CoreGraphics

final class EnemyFreezerSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let enemyFreezerComponents = nexus.getComponents(of: EnemyFreezerComponent.self)

        enemyFreezerComponents.forEach { enemyFreezerComponent in
            handleCollisions(enemyFreezerComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func handleCollisions(_ enemyFreezerComponent: EnemyFreezerComponent) {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: enemyFreezerComponent.entity)

        collisionComponents.forEach { collisionComponent in
            handleEnemyCollision(enemyFreezerComponent, collisionComponent)
        }
    }

    private func handleEnemyCollision(_ enemyFreezerComponent: EnemyFreezerComponent,
                                      _ collisionComponent: CollisionComponent) {
        let collidedEntity = collisionComponent.collidedEntity
        guard
            nexus.hasComponent(EnemyComponent.self, in: collidedEntity),
            !nexus.hasComponent(FreezeComponent.self, in: collidedEntity),
            let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: collidedEntity)
        else {
            return
        }

        let size = CGSize(width: Constants.enemyDiameter * 1.2, height: Constants.enemyDiameter * 1.2)
        let physicsBody = physicsComponent.physicsBody
        nexus.addComponent(FreezeComponent(entity: collidedEntity), to: collidedEntity)
        nexus.addComponent(RenderableComponent(entity: collidedEntity,
                                               image: .enemyFrozen,
                                               position: physicsBody.position,
                                               size: size,
                                               layer: .enemyEffect),
                           to: collidedEntity)
    }
}
