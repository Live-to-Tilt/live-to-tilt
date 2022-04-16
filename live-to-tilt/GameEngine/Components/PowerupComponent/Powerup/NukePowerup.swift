import CoreGraphics

class NukePowerup: Powerup {
    let orbImage: ImageAsset
    let activationScore: Int = Constants.nukeActivationScore

    init() {
        self.orbImage = .nukeOrb
    }

    func coroutine(nexus: Nexus, powerupPosition: CGPoint, playerComponent: PlayerComponent) {
        nexus.createNukeExplosion(position: powerupPosition)
    }
}

extension Nexus {
    func createNukeExplosion(position: CGPoint) {
        let entity = Entity()
        let size = CGSize(width: Constants.powerupDiameter, height: Constants.powerupDiameter)
        let physicsBody = PhysicsBody(isDynamic: false,
                                      shape: .circle,
                                      position: position,
                                      size: size,
                                      collisionBitmask: Constants.enemyAffectorCollisionBitmask)

        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: physicsBody),
                     to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: .nukeEffect,
                                         position: position,
                                         size: size,
                                         layer: .powerup),
                     to: entity)
        addComponent(EnemyKillerComponent(entity: entity, soundEffect: .nukeEnemyDeath), to: entity)
        addComponent(LifespanComponent(entity: entity, lifespan: Constants.nukeExplosionLifespan), to: entity)
        addComponent(AnimationComponent(entity: entity,
                                        animation: ScaleAnimation(initialSize: size,
                                                                  scale: Constants.nukeExplosionScale,
                                                                  duration: Constants.nukeExplosionAnimationDuration)),
                     to: entity)
    }
}
