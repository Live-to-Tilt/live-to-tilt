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
            !nexus.hasComponent(FrozenComponent.self, in: collidedEntity),
            let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: collidedEntity)
        else {
            return
        }

        // Add FreezeComponent
        let renderables = nexus.getComponents(of: RenderableComponent.self, for: collidedEntity)
        nexus.addComponent(FrozenComponent(entity: collidedEntity,
                                           timeLeft: Constants.frozenEnemyDuration,
                                           initialRenderables: renderables),
                           to: collidedEntity)

        // Add frozen overlay
        let position = physicsComponent.physicsBody.position
        let size = CGSize(width: Constants.frozenEnemyDiameter, height: Constants.frozenEnemyDiameter)
        nexus.addComponent(RenderableComponent(entity: collidedEntity,
                                               image: .enemyFrozen,
                                               position: position,
                                               size: size,
                                               layer: .enemyEffect),
                           to: collidedEntity)

        // Add vibrating animation
        let amplitude = CGVector(dx: Constants.enemyDiameter / 12, dy: 0)
        nexus.addComponent(AnimationComponent(entity: collidedEntity,
                                              animation: OscillateAnimation(initialPosition: position,
                                                                            amplitude: amplitude,
                                                                            frequency: 8)),
                           to: collidedEntity)
    }
}
