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
        let enemyFreezerId = enemyFreezerComponent.id
        guard nexus.hasComponent(EnemyComponent.self, in: collidedEntity) else {
            return
        }

        // If already frozen, check if collision is with a different enemyFreezer
        if let frozenComponent = nexus.getComponent(of: FrozenComponent.self, for: collidedEntity) {
            incrementFrozenDuration(frozenComponent, enemyFreezerId)
            return
        }

        freezeEnemy(enemyEntity: collidedEntity, enemyFreezerId)
    }

    private func incrementFrozenDuration(_ frozenComponent: FrozenComponent, _ enemyFreezerId: ObjectIdentifier) {
        let frozenBy = frozenComponent.frozenBy

        // If new enemyFreezer, increment frozen duration
        if !frozenBy.contains(enemyFreezerId) {
            frozenComponent.frozenBy.insert(enemyFreezerId)
            frozenComponent.timeLeft += Constants.frozenEnemyDuration
        }
    }

    private func freezeEnemy(enemyEntity: Entity, _ enemyFreezerId: ObjectIdentifier) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: enemyEntity) else {
            return
        }

        // Add FrozenComponent
        let renderables = nexus.getComponents(of: RenderableComponent.self, for: enemyEntity)
        nexus.addComponent(FrozenComponent(entity: enemyEntity,
                                           timeLeft: Constants.frozenEnemyDuration,
                                           initialRenderables: renderables,
                                           frozenBy: enemyFreezerId),
                           to: enemyEntity)

        // Add frozen overlay
        let position = physicsComponent.physicsBody.position
        let size = CGSize(width: Constants.frozenEnemyDiameter, height: Constants.frozenEnemyDiameter)
        nexus.addComponent(RenderableComponent(entity: enemyEntity,
                                               image: .enemyFrozen,
                                               position: position,
                                               size: size,
                                               layer: .enemyEffect),
                           to: enemyEntity)

        // Add vibrating animation
        let amplitude = CGVector(dx: Constants.enemyDiameter * Constants.frozenEnemyAmplitudeRatio,
                                 dy: .zero)
        let animation = OscillateAnimation(initialPosition: position,
                                           amplitude: amplitude,
                                           frequency: Constants.frozenEnemyOscillateFreq)
        nexus.addComponent(AnimationComponent(entity: enemyEntity,
                                              animation: animation),
                           to: enemyEntity)
    }
}
