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
                                                               categoryBitmask: Constants.wallCategoryBitmask,
                                                               collisionBitmask: Constants.wallCollisionBitmask)),
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

    func createPlayers(for gameMode: GameMode) {
        let entity = Entity()

        addComponent(PlayerComponent(entity: entity), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: .player,
                                         position: Constants.playerSpawnPosition,
                                         size: Constants.playerSize,
                                         layer: .player),
                     to: entity)
        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: PhysicsBody(isDynamic: true,
                                                               shape: .circle,
                                                               position: Constants.playerSpawnPosition,
                                                               size: Constants.playerColliderSize,
                                                               categoryBitmask: Constants.playerCategoryBitmask,
                                                               collisionBitmask: Constants.playerCollisionBitmask,
                                                               restitution: .zero)),
                     to: entity)

        if gameMode == .coop {
            createPlayerTwo()
        }
    }

    private func createPlayerTwo() {
        let entity = Entity()

        addComponent(PlayerComponent(entity: entity, isHost: false), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: .playerTwo,
                                         position: Constants.playerSpawnPosition,
                                         size: Constants.playerSize),
                     to: entity)
        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: PhysicsBody(isDynamic: true,
                                                               shape: .circle,
                                                               position: Constants.playerSpawnPosition,
                                                               size: Constants.playerColliderSize,
                                                               categoryBitmask: Constants.playerCategoryBitmask,
                                                               collisionBitmask: Constants.playerCollisionBitmask,
                                                               restitution: .zero)),
                     to: entity)
    }

    func createWaveSpawner(for gameMode: GameMode) {
        let entity = Entity()
        var waveSpawner: WaveSpawner
        switch gameMode {
        case .survival, .coop:
            waveSpawner = SurvivalWaveSpawner()
        case .gauntlet:
            waveSpawner = GauntletWaveSpawner()
        }

        addComponent(WaveSpawnerComponent(entity: entity, waveSpawner: waveSpawner),
                     to: entity)
    }

    func createPowerupSpawner(for gameMode: GameMode) {
        let entity = Entity()
        var powerupSpawner: PowerupSpawner
        switch gameMode {
        case .survival, .coop:
            powerupSpawner = SurvivalPowerupSpawner(nexus: self)
        case .gauntlet:
            powerupSpawner = GauntletPowerupSpawner(nexus: self)
        }

        addComponent(PowerupSpawnerComponent(entity: entity, powerupSpawner: powerupSpawner),
                     to: entity)
    }

    func createEnemy(position: CGPoint, movement: Movement, despawnOutsideArena: Bool = false) {
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
                                                               categoryBitmask: Constants.enemyCategoryBitmask,
                                                               collisionBitmask: Constants.enemyCollisionBitmask,
                                                               isTrigger: true)),
                     to: entity)
        addComponent(MovementComponent(entity: entity, movement: movement),
                     to: entity)
        addComponent(LifespanComponent(entity: entity, lifespan: Constants.enemyLifespan), to: entity)

        if despawnOutsideArena {
            addComponent(ArenaBoundaryComponent(entity: entity), to: entity)
        }
    }

    func createPowerup(position: CGPoint,
                       powerup: Powerup,
                       velocity: CGVector = .zero,
                       categoryBitmask: UInt32 = .zero,
                       collisionBitmask: UInt32 = .zero,
                       movement: Movement? = nil,
                       despawnOutsideArena: Bool = false) {
        let entity = Entity()
        let size = CGSize(width: Constants.powerupDiameter, height: Constants.powerupDiameter)

        addComponent(PowerupComponent(entity: entity, powerup: powerup), to: entity)
        addComponent(RenderableComponent(entity: entity,
                                         image: powerup.orbImage,
                                         position: position,
                                         size: size,
                                         layer: .powerup),
                     to: entity)
        addComponent(PhysicsComponent(entity: entity,
                                      physicsBody: PhysicsBody(isDynamic: true,
                                                               shape: Shape.circle,
                                                               position: position,
                                                               size: size,
                                                               categoryBitmask: categoryBitmask,
                                                               collisionBitmask: collisionBitmask,
                                                               velocity: velocity,
                                                               restitution: Constants.powerupRestitution)),
                     to: entity)
        addComponent(LifespanComponent(entity: entity), to: entity)

        if let powerupMovement = movement {
            addComponent(MovementComponent(entity: entity, movement: powerupMovement), to: entity)
        }

        if despawnOutsideArena {
            addComponent(ArenaBoundaryComponent(entity: entity), to: entity)
        }
    }

    func createCountdown(for gameMode: GameMode) {
        if gameMode == .gauntlet {
            let entity = Entity()
            addComponent(CountdownComponent(entity: entity, maxTime: Constants.gauntletMaxTime),
                         to: entity)
        }
    }
}
