import CoreGraphics

extension Nexus {
    static func generateRandomSpawnPosition(forEntityOfWidth width: CGFloat, height: CGFloat) -> CGPoint {
        let minX = width / 2
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio - minX
        let x = CGFloat.random(in: minX...maxX)

        let minY = height / 2
        let maxY = Constants.gameArenaHeight - minY
        let y = CGFloat.random(in: minY...maxY)

        let position = CGPoint(x: x, y: y)

        return position
    }

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

    func createPowerupManager(for gameMode: GameMode) {
        let entity = Entity()

        addComponent(PowerupManagerComponent(entity: entity, gameMode: gameMode),
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
        addComponent(LifespanComponent(entity: entity, lifespan: Constants.enemyLifespan), to: entity)
        EventManager.shared.postEvent(.enemySpawned)
    }

    func createPowerup(position: CGPoint, powerup: Powerup, velocity: CGVector = .zero) {
        let entity = Entity()
        let size = CGSize(width: Constants.powerupDiameter, height: Constants.powerupDiameter)

        addComponent(PowerupComponent(entity: entity, powerup: powerup), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: powerup.image,
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
                                                               velocity: velocity,
                                                               restitution: Constants.powerupRestitution)),
                     to: entity)
        EventManager.shared.postEvent(.powerUpSpawned)
    }

    func createCountdown(for gameMode: GameMode) {
        if gameMode == .gauntlet {
            let entity = Entity()
            addComponent(CountdownComponent(entity: entity, maxTime: Constants.gauntletMaxTime),
                         to: entity)
        }
    }

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
