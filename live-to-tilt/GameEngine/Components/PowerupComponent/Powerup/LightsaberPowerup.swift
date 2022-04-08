import CoreGraphics

class LightsaberPowerup: Powerup {
    let orbImage: ImageAsset
    let activationScore: Int = Constants.lightsaberActivationScore

    init() {
        self.orbImage = .lightsaberOrb
    }

    func coroutine(nexus: Nexus, powerupPosition: CGPoint) {
        nexus.createLightsaberAura()
    }
}

extension Nexus {
    func createLightsaberAura() {
        guard
            let playerEntity = getEntity(with: PlayerComponent.self),
            let physicsComponent = getComponent(of: PhysicsComponent.self, for: playerEntity) else {
            return
        }
        let playerPhysicsBody = physicsComponent.physicsBody
        let playerPosition = playerPhysicsBody.position
        let playerRotation = playerPhysicsBody.rotation
        let entity = Entity()
        var movement: Movement = BaseMovement()
        movement = AttachMovementDecorator(movement: movement, target: playerEntity)

        addComponent(MovementComponent(entity: entity, movement: movement), to: entity)
        let physicsBody = PhysicsBody(isDynamic: false,
                                      shape: .rectangle,
                                      position: playerPosition,
                                      size: Constants.lightsaberSize,
                                      collisionBitMask: Constants.enemyAffectorCollisionBitMask,
                                      rotation: playerRotation)
        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: physicsBody),
                     to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: .lightsaberEffect,
                                         position: playerPosition,
                                         size: Constants.lightsaberSize),
                     to: entity)
        addComponent(EnemyKillerComponent(entity: entity), to: entity)
        addComponent(LifespanComponent(entity: entity, lifespan: Constants.lightsaberLifespan), to: entity)
    }
}
