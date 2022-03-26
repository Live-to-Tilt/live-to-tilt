import CoreGraphics

final class PowerupSystem: System {
    let nexus: Nexus
    private var elapsedTimeSincePreviousSpawn: CGFloat = .zero

    private var numberOfPowerupsInArena: Int {
        let powerupComponents = nexus.getComponents(of: PowerupComponent.self)

        return powerupComponents.filter({ !$0.isActive }).count
    }

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        manageSpawning(for: deltaTime)

        let powerupComponents = nexus.getComponents(of: PowerupComponent.self)

        powerupComponents.forEach { powerupComponent in
            updatePowerup(powerupComponent, for: deltaTime)
            handleCollisions(powerupComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func manageSpawning(for deltaTime: CGFloat) {
        self.elapsedTimeSincePreviousSpawn += deltaTime

        if self.elapsedTimeSincePreviousSpawn > Constants.powerupSpawnInterval {
            resetElapsedTime()
            spawnPowerup()
        }
    }

    private func resetElapsedTime() {
        self.elapsedTimeSincePreviousSpawn.formTruncatingRemainder(dividingBy: Constants.powerupSpawnInterval)
    }

    private func spawnPowerup() {
        guard numberOfPowerupsInArena < Constants.maxNumberOfPowerupsInArena else {
            return
        }

        let randomSpawnLocation = getRandomSpawnLocation()
        nexus.createPowerup(position: randomSpawnLocation)
    }

    private func getRandomSpawnLocation() -> CGPoint {
        let minX = Constants.powerupDiameter / 2
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio - minX
        let x = CGFloat.random(in: minX...maxX)

        let minY = Constants.enemyDiameter / 2
        let maxY = Constants.gameArenaHeight - minY
        let y = CGFloat.random(in: minY...maxY)

        let position = CGPoint(x: x, y: y)

        return position
    }

    private func updatePowerup(_ powerupComponent: PowerupComponent, for deltaTime: CGFloat) {
        powerupComponent.elapsedTimeSinceSpawn += deltaTime

        if powerupComponent.isActive {
            powerupComponent.effect.update(for: deltaTime)
        }
    }

    private func handleCollisions(_ powerupComponent: PowerupComponent) {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: powerupComponent.entity)

        collisionComponents.forEach { collisionComponent in
            handlePlayerCollision(powerupComponent, collisionComponent)
        }
    }

    private func handlePlayerCollision(_ powerupComponent: PowerupComponent, _ collisionComponent: CollisionComponent) {
        guard nexus.hasComponent(PlayerComponent.self, in: collisionComponent.collidedEntity) else {
            return
        }

        if powerupComponent.elapsedTimeSinceSpawn > Constants.delayBeforePowerupIsActivatable {
            powerupComponent.isActive = true
            if powerupComponent.effect is NukeEffect {
                EventManager.postEvent(.nukePowerUpUsed)
            }
        }
    }
}
