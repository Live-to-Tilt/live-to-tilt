import CoreGraphics

class FreezePowerup: Powerup {
    let orbImage: ImageAsset
    let activationScore: Int = Constants.freezeActivationScoree

    init() {
        self.orbImage = .freezeOrb
    }

    func coroutine(nexus: Nexus, powerupPosition: CGPoint) {
        nexus.createFreezeEffect(position: powerupPosition)
    }
}

extension Nexus {
    func createFreezeEffect(position: CGPoint) {
        let entity = Entity()
        let size = CGSize(width: Constants.powerupDiameter, height: Constants.powerupDiameter)
        let physicsBody = PhysicsBody(isDynamic: false,
                                      shape: .circle,
                                      position: position,
                                      size: size,
                                      collisionBitMask: Constants.enemyAffectorCollisionBitMask)
        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: physicsBody),
                     to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: .freezeEffect,
                                         position: position,
                                         size: size,
                                         layer: .powerup),
                     to: entity)
        addComponent(EnemyFreezerComponent(entity: entity), to: entity)
//        TODO: replace constants
        addComponent(LifespanComponent(entity: entity, lifespan: Constants.nukeExplosionLifespan), to: entity)
        addComponent(AnimationComponent(entity: entity,
                                        animation: ScaleAnimation(initialSize: size,
                                                                  scale: Constants.nukeExplosionScale,
                                                                  duration: Constants.nukeExplosionAnimationDuration)),
                     to: entity)
    }
}
