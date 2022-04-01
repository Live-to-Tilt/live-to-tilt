import CoreGraphics

/**
 Encapsulates the effects of the Lightsaber powerup.
 
 When activated, the Player will gain a Lightsaber, which follows the Player around and destroys enemies it comes
 into contact with.
 
 See https://tilttolive.fandom.com/wiki/Nuke for more details.
 */
class LightsaberEffect: PowerupEffect {
    let nexus: Nexus
    let powerupEntity: Entity
    let orbImage: ImageAsset = .lightsaberOrb
    let image: ImageAsset = .lightsaberEffect
    private var elapsedTime: CGFloat = .zero
    private var hasCompleted: Bool {
        self.elapsedTime >= Constants.lightsaberDuration
    }

    init(nexus: Nexus, powerupEntity: Entity) {
        self.nexus = nexus
        self.powerupEntity = powerupEntity
    }

    func activate() {
        guard let powerupPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: powerupEntity),
              let powerupRenderableComponent = nexus.getComponent(of: RenderableComponent.self, for: powerupEntity),
              let playerEntity = nexus.getEntity(with: PlayerComponent.self),
              let playerPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: playerEntity) else {
            return
        }

        let powerupPhysicsBody = powerupPhysicsComponent.physicsBody
        let playerPhysicsBody = playerPhysicsComponent.physicsBody
        let playerPosition = playerPhysicsBody.position
        let playerRotation = playerPhysicsBody.rotation
        powerupPhysicsBody.isDynamic = false
        powerupPhysicsBody.shape = .rectangle
        powerupPhysicsBody.position = playerPosition
        powerupPhysicsBody.size = Constants.lightsaberSize
        powerupPhysicsBody.collisionBitMask = Constants.enemyAffectorCollisionBitMask
        powerupPhysicsBody.velocity = .zero
        powerupPhysicsBody.rotation = playerRotation
        powerupRenderableComponent.image = self.image
        powerupRenderableComponent.size = Constants.lightsaberSize

        EventManager.shared.postEvent(.lightsaberPowerUpUsed)
    }

    func update(for deltaTime: CGFloat) {
        guard let powerupPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: powerupEntity),
              let playerEntity = nexus.getEntity(with: PlayerComponent.self),
              let playerPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: playerEntity) else {
            return
        }

        if self.hasCompleted {
            nexus.removeEntity(powerupEntity)
        }

        handleCollisions()

        let powerupPhysicsBody = powerupPhysicsComponent.physicsBody
        let playerPhysicsBody = playerPhysicsComponent.physicsBody
        let playerPosition = playerPhysicsBody.position
        let playerRotation = playerPhysicsBody.rotation
        powerupPhysicsBody.position = playerPosition
        powerupPhysicsBody.rotation = playerRotation
        self.elapsedTime += deltaTime
    }

    private func handleCollisions() {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: self.powerupEntity)

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
