import CoreGraphics

/**
 Encapsulates the effects of the Lightsaber powerup.
 
 When activated, the Player will gain a Lightsaber, which follows the Player around and destroys enemies it comes
 into contact with.
 */
class LightsaberEffect: PowerupEffect {
    let orbImage: ImageAsset = .lightsaberOrb
    private let nexus: Nexus
    private let powerupEntity: Entity
    private let image: ImageAsset = .lightsaberEffect
    private var elapsedTime: CGFloat = .zero
    private var hasCompleted: Bool {
        elapsedTime >= Constants.lightsaberDuration
    }

    init(nexus: Nexus, powerupEntity: Entity) {
        self.nexus = nexus
        self.powerupEntity = powerupEntity
    }

    func activate() {
        transformOrbToLightsaber()
        attachLightsaberToPlayer()

        EventManager.shared.postEvent(.lightsaberPowerupUsed)
    }

    func update(for deltaTime: CGFloat) {
        if hasCompleted {
            nexus.removeEntity(powerupEntity)
        }

        handleCollisions()
        updateElapsedTime(deltaTime: deltaTime)
    }

    private func transformOrbToLightsaber() {
        guard let powerupPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: powerupEntity),
              let powerupRenderableComponent = nexus.getComponent(of: RenderableComponent.self,
                                                                  for: powerupEntity) else {
            return
        }

        let powerupPhysicsBody = powerupPhysicsComponent.physicsBody

        powerupPhysicsBody.isDynamic = false
        powerupPhysicsBody.shape = .rectangle
        powerupPhysicsBody.size = Constants.lightsaberSize
        powerupPhysicsBody.collisionBitMask = Constants.enemyAffectorCollisionBitMask
        powerupPhysicsBody.velocity = .zero
        powerupRenderableComponent.image = self.image
        powerupRenderableComponent.size = Constants.lightsaberSize
    }

    private func attachLightsaberToPlayer() {
        guard let playerEntity = nexus.getEntity(with: PlayerComponent.self) else {
            return
        }

        let movement = BaseMovement()
        let attachMovement = AttachMovementDecorator(movement: movement, target: playerEntity)

        nexus.addComponent(MovementComponent(entity: powerupEntity, movement: attachMovement),
                           to: powerupEntity)
    }

    private func updateElapsedTime(deltaTime: CGFloat) {
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
