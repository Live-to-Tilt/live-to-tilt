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
        let powerupEntity = powerupComponent.entity
        let collidedEntity = collisionComponent.collidedEntity
        guard let playerComponent = nexus.getComponent(of: PlayerComponent.self, for: collidedEntity),
              !isRecentlySpawned(powerupComponent),
              let powerupPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self,
                                                               for: powerupEntity) else {
            return
        }

        let powerup = powerupComponent.powerup
        let powerupPhysicsBody = powerupPhysicsComponent.physicsBody
        let powerupPosition = powerupPhysicsBody.position

        powerup.activate(nexus: nexus, at: powerupPosition, by: playerComponent)
        nexus.removeEntity(powerupEntity)
    }

    private func isRecentlySpawned(_ powerupComponent: PowerupComponent) -> Bool {
        guard let lifespanComponent = nexus.getComponent(of: LifespanComponent.self,
                                                         for: powerupComponent.entity) else {
            return false
        }

        return lifespanComponent.elapsedTimeSinceSpawn < Constants.delayBeforePowerupIsActivatable
    }
}
