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

    func createPowerup(position: CGPoint, type: PowerupType) {
        let entity = Entity()
        let size = CGSize(width: Constants.powerupDiameter, height: Constants.powerupDiameter)
        var image: ImageAsset

        switch type {
        case .nuke:
            image = .nuke
            addComponent(NukePowerupComponent(entity: entity), to: entity)
        }

        addComponent(PowerupComponent(entity: entity), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: image,
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
