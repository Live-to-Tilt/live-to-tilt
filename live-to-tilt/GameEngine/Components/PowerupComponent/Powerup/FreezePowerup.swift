import CoreGraphics

class FreezePowerup: Powerup {
    let orbImage: ImageAsset
    let activationScore: Int = Constants.freezeActivationScore

    init() {
        self.orbImage = .freezeOrb
    }

    func coroutine(nexus: Nexus, powerupPosition: CGPoint, playerComponent: PlayerComponent) {
        AudioController.shared.play(.freeze)
        nexus.createFreezeBlast(position: powerupPosition)
    }
}

extension Nexus {
    func createFreezeBlast(position: CGPoint) {
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
                                         image: .freezeEffect,
                                         position: position,
                                         size: size,
                                         opacity: Constants.freezeBlastOpacity,
                                         layer: .powerup),
                     to: entity)
        addComponent(EnemyFreezerComponent(entity: entity), to: entity)
        addComponent(LifespanComponent(entity: entity, lifespan: Constants.freezeBlastLifespan), to: entity)
        addComponent(AnimationComponent(entity: entity,
                                        animation: ScaleAnimation(initialSize: size,
                                                                  scale: Constants.freezeBlastScale,
                                                                  duration: Constants.freezeBlastAnimationDuration)),
                     to: entity)
    }
}
