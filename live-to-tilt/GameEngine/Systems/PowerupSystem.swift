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
            updateEffectIfActive(powerupComponent, deltaTime: deltaTime)
            handleCollisions(powerupComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updateElapsedTime(_ powerupComponent: PowerupComponent, deltaTime: CGFloat) {
        powerupComponent.elapsedTimeSinceSpawn += deltaTime
    }

    private func updateEffectIfActive(_ powerupComponent: PowerupComponent, deltaTime: CGFloat) {
        if powerupComponent.isActive {
            powerupComponent.effect.update(for: deltaTime)
        }
    }

    private func handleCollisions(_ powerupComponent: PowerupComponent) {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: powerupComponent.entity)

        collisionComponents.forEach { collisionComponent in
            handlePlayerCollision(powerupComponent, collisionComponent)
        }
    }

    private func handlePlayerCollision(_ powerupComponent: PowerupComponent, _ collisionComponent: CollisionComponent) {
        guard powerupComponent.elapsedTimeSinceSpawn > Constants.delayBeforePowerupIsActivatable,
              nexus.hasComponent(PlayerComponent.self, in: collisionComponent.collidedEntity),
              !powerupComponent.isActive else {
            return
        }

        powerupComponent.isActive = true
        powerupComponent.effect.activate()
        nexus.createPowerup()
    }
}
