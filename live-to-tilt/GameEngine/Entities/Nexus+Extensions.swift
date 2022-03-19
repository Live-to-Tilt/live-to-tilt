import CoreGraphics

extension Nexus {
    func createPlayer() {
        let entity = Entity()

        addComponent(PlayerComponent(entity: entity), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: .player,
                                         position: Constants.playerSpawnPosition,
                                         size: Constants.playerSize),
                     to: entity)
        addComponent(PhysicsComponent(entity: entity, physicsBody: PhysicsBody(isDynamic: true,
                                                                               shape: .circle,
                                                                               position: Constants.playerSpawnPosition,
                                                                               size: Constants.playerSize)),
                     to: entity)
    }

    func createEnemy(position: CGPoint, movement: Movement) {
        let entity = Entity()
        let transform = CGAffineTransform(scaleX: Constants.enemyFrontToBackRatio, y: Constants.enemyFrontToBackRatio)
        let enemyBackSize = CGSize(width: Constants.enemyDiameter, height: Constants.enemyDiameter)
        let enemyFrontSize = enemyBackSize.applying(transform)

        addComponent(EnemyComponent(entity: entity, movement: movement), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: .enemyFront,
                                         position: position,
                                         size: enemyFrontSize,
                                         layer: .enemyFront),
                     to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: .enemyBack,
                                         position: position,
                                         size: enemyBackSize,
                                         layer: .enemyBack),
                     to: entity)
        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: PhysicsBody(isDynamic: true,
                                                               shape: .circle,
                                                               position: position,
                                                               size: enemyFrontSize,
                                                               isTrigger: true)),
                     to: entity)
    }

    func createPowerup(position: CGPoint) {
        let entity = Entity()
        let size = CGSize(width: Constants.powerupDiameter, height: Constants.powerupDiameter)
        let effects = [
            NukeEffect(nexus: self, entity: entity)
        ]

        guard let effect = effects.randomElement() else {
            return
        }

        addComponent(PowerupComponent(entity: entity, effect: effect), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: effect.image,
                                         position: position,
                                         size: size,
                                         layer: .powerup),
                     to: entity)
        addComponent(PhysicsComponent(entity: entity, physicsBody: PhysicsBody(isDynamic: true,
                                                                               shape: Shape.circle,
                                                                               position: position,
                                                                               size: size,
                                                                               isTrigger: true)),
                     to: entity)
    }
}
