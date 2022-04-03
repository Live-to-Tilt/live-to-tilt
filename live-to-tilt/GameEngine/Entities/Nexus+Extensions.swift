import CoreGraphics

extension Nexus {
    func createWalls() {
        createWall(position: Constants.topWallPosition, size: Constants.horizontalWallSize)
        createWall(position: Constants.bottomWallPosition, size: Constants.horizontalWallSize)
        createWall(position: Constants.leftWallPosition, size: Constants.verticalWallSize)
        createWall(position: Constants.rightWallPosition, size: Constants.verticalWallSize)
    }

    func createWall(position: CGPoint, size: CGSize) {
        let entity = Entity()

        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: PhysicsBody(isDynamic: false,
                                                               shape: .rectangle,
                                                               position: position,
                                                               size: size,
                                                               collisionBitMask: Constants.wallCollisionBitMask)),
                     to: entity)
    }

    func createGameState() {
        let entity = Entity()

        addComponent(GameStateComponent(entity: entity), to: entity)
    }

    func createCombo() {
        let entity = Entity()

        addComponent(ComboComponent(entity: entity), to: entity)
    }

    func createPlayer() {
        let entity = Entity()

        addComponent(PlayerComponent(entity: entity), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: .player,
                                         position: Constants.playerSpawnPosition,
                                         size: Constants.playerSize),
                     to: entity)
        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: PhysicsBody(isDynamic: true,
                                                               shape: .circle,
                                                               position: Constants.playerSpawnPosition,
                                                               size: Constants.playerColliderSize,
                                                               collisionBitMask: Constants.playerCollisionBitMask,
                                                               restitution: .zero)),
                     to: entity)
    }

    func createWaveManager(for gameMode: GameMode) {
        let entity = Entity()

        addComponent(WaveManagerComponent(entity: entity, gameMode: gameMode),
                     to: entity)
    }

    func createEnemy(position: CGPoint, movement: Movement) {
        let entity = Entity()
        let transform = CGAffineTransform(scaleX: Constants.enemyFrontToBackRatio, y: Constants.enemyFrontToBackRatio)
        let enemyBackSize = CGSize(width: Constants.enemyDiameter, height: Constants.enemyDiameter)
        let enemyFrontSize = enemyBackSize.applying(transform)

        addComponent(EnemyComponent(entity: entity), to: entity)
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
                                                               collisionBitMask: Constants.enemyCollisionBitMask,
                                                               isTrigger: true)),
                     to: entity)
        addComponent(MovementComponent(entity: entity, movement: movement),
                     to: entity)
        EventManager.shared.postEvent(.enemySpawned)
    }

    func createPowerups() {
        for _ in 1...Constants.maxNumberOfPowerupsInArena {
            createPowerup()
        }
    }

    func createPowerup() {
        let entity = Entity()
        let size = CGSize(width: Constants.powerupDiameter, height: Constants.powerupDiameter)
        let position = generateRandomSpawnLocation(forEntityOfWidth: Constants.powerupDiameter,
                                                   height: Constants.powerupDiameter)
        let effects: [PowerupEffect] = [
            NukeEffect(nexus: self, powerupEntity: entity),
            LightsaberEffect(nexus: self, powerupEntity: entity)
        ]

        guard let effect = effects.randomElement() else {
            return
        }

        addComponent(PowerupComponent(entity: entity, effect: effect), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: effect.orbImage,
                                         position: position,
                                         size: size,
                                         layer: .powerup),
                     to: entity)
        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: PhysicsBody(isDynamic: true,
                                                               shape: Shape.circle,
                                                               position: position,
                                                               size: size,
                                                               collisionBitMask: Constants.powerupCollisionBitMask,
                                                               velocity:
                                                                CGVector.random(magnitude: Constants.maxPowerupSpeed),
                                                               restitution: Constants.powerupRestitution)),
                     to: entity)
        EventManager.shared.postEvent(.powerUpSpawned)
    }

    private func generateRandomSpawnLocation(forEntityOfWidth width: CGFloat, height: CGFloat) -> CGPoint {
        let minX = width / 2
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio - minX
        let x = CGFloat.random(in: minX...maxX)

        let minY = height / 2
        let maxY = Constants.gameArenaHeight - minY
        let y = CGFloat.random(in: minY...maxY)

        let position = CGPoint(x: x, y: y)

        return position
    }
}
