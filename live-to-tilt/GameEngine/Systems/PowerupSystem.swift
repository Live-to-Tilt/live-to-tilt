import CoreGraphics

final class PowerupSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let powerupComponents = nexus.getComponents(of: PowerupComponent.self)

        powerupComponents.forEach { powerupComponent in
            updateElapsedTime(powerupComponent, deltaTime: deltaTime)
            handleCollisions(powerupComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updateElapsedTime(_ powerupComponent: PowerupComponent, deltaTime: CGFloat) {
        powerupComponent.elapsedTimeSinceSpawn += deltaTime
    }

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
        powerup.activate(nexus: nexus)
        nexus.removeEntity(powerupEntity)
    }

    private func isRecentlySpawned(_ powerupComponent: PowerupComponent) -> Bool {
        powerupComponent.elapsedTimeSinceSpawn < Constants.delayBeforePowerupIsActivatable
    }
}
