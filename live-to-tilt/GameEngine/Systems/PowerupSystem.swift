import CoreGraphics

final class PowerupSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let powerupComponents = nexus.getComponents(of: PowerupComponent.self)

        powerupComponents.forEach { powerupComponent in
            handleCollisions(powerupComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func handleCollisions(_ powerupComponent: PowerupComponent) {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: powerupComponent.entity)

        collisionComponents.forEach { collisionComponent in
            handlePlayerCollision(powerupComponent, collisionComponent)
        }
    }

    private func handlePlayerCollision(_ powerupComponent: PowerupComponent, _ collisionComponent: CollisionComponent) {
        let collidedEntity = collisionComponent.collidedEntity
        if !nexus.hasComponent(PlayerComponent.self, in: collidedEntity) {
            return
        }

        if isRecentlySpawned(powerupComponent) {
            return
        }

        let powerup = powerupComponent.powerup
        let powerupEntity = powerupComponent.entity

        guard let powerupPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: powerupEntity) else {
            return
        }

        let powerupPhysicsBody = powerupPhysicsComponent.physicsBody
        let powerupPosition = powerupPhysicsBody.position

        powerup.activate(nexus: nexus, at: powerupPosition)
        nexus.removeEntity(powerupEntity)
    }

    private func isRecentlySpawned(_ enemyComponent: PowerupComponent) -> Bool {
        guard let lifespanComponent = nexus.getComponent(of: LifespanComponent.self, for: enemyComponent.entity) else {
            return false
        }
        return lifespanComponent.elapsedTimeSinceSpawn < Constants.enemySpawnDelay
    }
}
