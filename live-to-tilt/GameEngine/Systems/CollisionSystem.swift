import CoreGraphics

class CollisionSystem: System {
    let nexus: Nexus
    let physicsWorld: PhysicsWorld

    init(nexus: Nexus, physicsWorld: PhysicsWorld) {
        self.nexus = nexus
        self.physicsWorld = physicsWorld
        self.physicsWorld.collisionDelegate = self
    }

    func update(deltaTime: CGFloat) {

    }
}

// MARK: PhysicsCollisionDelegate
extension CollisionSystem: PhysicsCollisionDelegate {
    func didBegin(_ collision: Collision) {
        guard let entityA = getEntityFromPhysicsBody(collision.bodyA),
                let entityB = getEntityFromPhysicsBody(collision.bodyB) else {
            return
        }

        if isCollisionBetweenPlayerAndPowerup(entityA: entityA, entityB: entityB) {
            respondToCollisionBetweenPlayerAndPowerup(entityA: entityA, entityB: entityB)
        }

        if isCollisionBetweenNukeAndEnemy(entityA: entityA, entityB: entityB) {
            respondToCollisionBetweenNukeAndEnemy(entityA: entityA, entityB: entityB)
        }

        if isCollisionBetweenPlayerAndEnemy(entityA: entityA, entityB: entityB) {
            respondToCollisionBetweenPlayerAndEnemy(entityA: entityA, entityB: entityB)
        }
    }

    func didEnd(_ collision: Collision) {
    }

    private func getEntityFromPhysicsBody(_ physicsBody: PhysicsBody) -> Entity? {
        let physicsComponents = nexus.getComponents(of: PhysicsComponent.self)

        guard let physicsComponent = physicsComponents.first(where: { $0.physicsBody === physicsBody }) else {
            return nil
        }

        return physicsComponent.entity
    }

    private func isCollisionBetweenPlayerAndPowerup(entityA: Entity, entityB: Entity) -> Bool {
        isPlayerPowerupCollision(entityA, entityB) || isPlayerPowerupCollision(entityB, entityA)
    }

    private func isCollisionBetweenNukeAndEnemy(entityA: Entity, entityB: Entity) -> Bool {
        isNukeEnemyCollision(entityA, entityB) || isNukeEnemyCollision(entityB, entityA)
    }

    private func isCollisionBetweenPlayerAndEnemy(entityA: Entity, entityB: Entity) -> Bool {
        isPlayerEnemyCollision(entityA, entityB) || isPlayerEnemyCollision(entityB, entityA)
    }

    private func isPlayerPowerupCollision(_ entityA: Entity, _ entityB: Entity) -> Bool {
        nexus.hasComponent(PlayerComponent.self, in: entityA) && nexus.hasComponent(PowerupComponent.self, in: entityB)
    }

    private func isNukeEnemyCollision(_ entityA: Entity, _ entityB: Entity) -> Bool {
        guard let powerupComponent = nexus.getComponent(of: PowerupComponent.self, for: entityA) else {
            return false
        }

        return powerupComponent.effect is NukeEffect && nexus.hasComponent(EnemyComponent.self, in: entityB)
    }

    private func isPlayerEnemyCollision(_ entityA: Entity, _ entityB: Entity) -> Bool {
        nexus.hasComponent(PlayerComponent.self, in: entityA) && nexus.hasComponent(EnemyComponent.self, in: entityB)
    }

    private func respondToCollisionBetweenPlayerAndPowerup(entityA: Entity, entityB: Entity) {
        let entityWithPowerupComponent = nexus.hasComponent(PowerupComponent.self, in: entityA) ? entityA : entityB

        guard let powerupComponent = nexus.getComponent(of: PowerupComponent.self,
                                                        for: entityWithPowerupComponent),
              powerupComponent.elapsedTimeSinceSpawn > Constants.delayBeforePowerupIsActivatable else {
            return
        }

        powerupComponent.isActive = true
    }

    private func respondToCollisionBetweenNukeAndEnemy(entityA: Entity, entityB: Entity) {
        let enemyEntity = nexus.hasComponent(EnemyComponent.self, in: entityA) ? entityA : entityB
        let nukeEntity = nexus.hasComponent(PowerupComponent.self, in: entityA) ? entityA : entityB

        guard let powerupComponent = nexus.getComponent(of: PowerupComponent.self, for: nukeEntity),
              powerupComponent.isActive else {
            return
        }

        nexus.removeEntity(enemyEntity)
    }

    private func respondToCollisionBetweenPlayerAndEnemy(entityA: Entity, entityB: Entity) {
        let gameStateComponent = nexus.getComponent(of: GameStateComponent.self)

        gameStateComponent?.state = .gameOver
    }
}
