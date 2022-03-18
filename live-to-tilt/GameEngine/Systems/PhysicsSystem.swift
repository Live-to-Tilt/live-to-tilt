import CoreGraphics

class PhysicsSystem: System {
    let nexus: Nexus

    let physicsWorld = PhysicsWorld()

    init(nexus: Nexus) {
        self.nexus = nexus
        self.physicsWorld.contactDelegate = self
    }

    func update(deltaTime: CGFloat) {
        let entities = nexus.getEntities(with: PhysicsComponent.self)

        entities.forEach { entity in
            updateRenderable(entity)
        }

        updatePhysicsBodies(deltaTime: deltaTime)
    }

    private func updatePhysicsBodies(deltaTime: CGFloat) {
        let physicsBodies = nexus.getComponents(of: PhysicsComponent.self).map { $0.physicsBody }
        physicsWorld.update(physicsBodies, deltaTime: deltaTime)
    }

    private func updateRenderable(_ entity: Entity) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
            return
        }

        let renderableComponents = nexus.getComponents(of: RenderableComponent.self, for: entity)

        renderableComponents.forEach { renderableComponent in
            renderableComponent.position = physicsComponent.physicsBody.position
            renderableComponent.rotation = physicsComponent.physicsBody.rotation
        }
    }
}

// MARK: PhysicsCollisionDelegate
// `PhysicsSystem` is a `PhysicsCollisionDelegate` since it implements custom game logic when a collision is detected
// in the Physics Engine.
extension PhysicsSystem: PhysicsCollisionDelegate {
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
        let isPowerupPlayerCollision = nexus.hasComponent(PowerupComponent.self, in: entityA)
            && nexus.hasComponent(PlayerComponent.self, in: entityB)

        let isPlayerPowerupCollision = nexus.hasComponent(PlayerComponent.self, in: entityA)
            && nexus.hasComponent(PowerupComponent.self, in: entityB)

        return isPowerupPlayerCollision || isPlayerPowerupCollision
    }

    private func isCollisionBetweenNukeAndEnemy(entityA: Entity, entityB: Entity) -> Bool {
        let isNukeEnemyCollision = nexus.hasComponent(NukePowerupComponent.self, in: entityA)
            && nexus.hasComponent(EnemyComponent.self, in: entityB)

        let isEnemyNukeCollision = nexus.hasComponent(EnemyComponent.self, in: entityA)
            && nexus.hasComponent(NukePowerupComponent.self, in: entityB)

        return isNukeEnemyCollision || isEnemyNukeCollision
    }

    private func respondToCollisionBetweenPlayerAndPowerup(entityA: Entity, entityB: Entity) {
        let entityWithPowerupComponent = nexus.hasComponent(PowerupComponent.self, in: entityA) ? entityA : entityB

        guard let powerupComponent = nexus.getComponent(of: PowerupComponent.self,
                                                        for: entityWithPowerupComponent) else {
            return
        }

        powerupComponent.activate()
    }

    private func respondToCollisionBetweenNukeAndEnemy(entityA: Entity, entityB: Entity) {
        let enemyEntity = nexus.hasComponent(EnemyComponent.self, in: entityA) ? entityA : entityB
        nexus.removeEntity(enemyEntity)
    }
}
