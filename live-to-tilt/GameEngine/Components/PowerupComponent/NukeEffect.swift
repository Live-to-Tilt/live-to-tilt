import CoreGraphics

/**
 Encapsulates the effects of the Nuke powerup.
 
 When activated, the Nuke powerup will explode, destroying all nearby Enemies.
 
 See https://tilttolive.fandom.com/wiki/Nuke for more details.
 */
class NukeEffect: PowerupEffect {
    let nexus: Nexus
    let powerupEntity: Entity
    let orbImage: ImageAsset = .nukeOrb
    let image: ImageAsset = .nukeEffect
    private var currentExplosionRadius: CGFloat = Constants.powerupDiameter / 2
    private var elapsedTimeSinceExpansionComplete: CGFloat = .zero
    private var hasCompletedExpansion: Bool {
        self.currentExplosionRadius > Constants.nukeExplosionDiameter / 2
    }
    private var hasCompleted: Bool {
        self.elapsedTimeSinceExpansionComplete >= Constants.nukeCompletionDelay
    }

    init(nexus: Nexus, powerupEntity: Entity) {
        self.nexus = nexus
        self.powerupEntity = powerupEntity
    }

    func activate() {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: powerupEntity),
              let renderableComponent = nexus.getComponent(of: RenderableComponent.self, for: powerupEntity) else {
            return
        }

        let physicsBody = physicsComponent.physicsBody
        physicsBody.collisionBitMask = Constants.nukeEffectCollisionBitMask
        physicsBody.velocity = .zero
        renderableComponent.image = self.image

        EventManager.shared.postEvent(.nukePowerUpUsed)
    }

    func update(for deltaTime: CGFloat) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: powerupEntity),
              let renderableComponent = nexus.getComponent(of: RenderableComponent.self, for: powerupEntity) else {
            return
        }

        if self.hasCompleted {
            nexus.removeEntity(powerupEntity)
        } else if self.hasCompletedExpansion {
            self.elapsedTimeSinceExpansionComplete += deltaTime
        } else {
            let timeFraction = deltaTime / Constants.nukeExplosionDuration
            let deltaRadius = (Constants.nukeExplosionDiameter / 2 - Constants.powerupDiameter / 2) * timeFraction

            let physicsBody = physicsComponent.physicsBody
            physicsBody.size += deltaRadius
            self.currentExplosionRadius += deltaRadius
            renderableComponent.size += deltaRadius
        }

        handleCollisions()
    }

    private func handleCollisions() {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: powerupEntity)

        collisionComponents.forEach { collisionComponent in
            handleEnemyCollision(collisionComponent)
        }
    }

    private func handleEnemyCollision(_ collisionComponent: CollisionComponent) {
        guard let enemyComponent = nexus.getComponent(of: EnemyComponent.self,
                                                      for: collisionComponent.collidedEntity) else {
            return
        }

        nexus.removeEntity(enemyComponent.entity)
    }
}
