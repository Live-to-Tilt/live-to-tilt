import CoreGraphics

final class PowerupSystem: System {
    let nexus: Nexus
    private var elapsedTimeSincePreviousSpawn: CGFloat = 0

    private var numberOfPowerupsInArena: Int {
        let powerupComponents = nexus.getComponents(of: PowerupComponent.self)

        return powerupComponents.filter({ !$0.isActive }).count
    }

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        manageSpawning(for: deltaTime)
        updatePowerups(for: deltaTime)
        updateActivePowerups(for: deltaTime)
    }

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
        guard numberOfPowerupsInArena < Constants.maxNumberOfPowerupsInArena,
              let randomPowerupType = PowerupType.allCases.randomElement() else {
            return
        }

        let randomSpawnLocation = getRandomSpawnLocation()
        nexus.createPowerup(position: randomSpawnLocation, type: randomPowerupType)
    }

    private func getRandomSpawnLocation() -> CGPoint {
        let minX = Constants.powerupDiameter / 2
        let maxX = Constants.gameArenaWidth - minX
        let x = CGFloat.random(in: minX...maxX)

        let minY = Constants.enemyDiameter / 2
        let maxY = Constants.gameArenaHeight - minY
        let y = CGFloat.random(in: minY...maxY)

        let position = CGPoint(x: x, y: y)

        return position
    }

    // Updates all powerups
    private func updatePowerups(for deltaTime: CGFloat) {
        let powerupComponents = nexus.getComponents(of: PowerupComponent.self)

        for powerupComponent in powerupComponents {
            powerupComponent.elapsedTimeSinceSpawn += deltaTime
        }
    }

    // Updates only active powerups
    private func updateActivePowerups(for deltaTime: CGFloat) {
        let powerupComponents = nexus.getComponents(of: PowerupComponent.self)
        let activePowerupComponents = powerupComponents.filter({ $0.isActive })

        for powerupComponent in activePowerupComponents {
            let entity = powerupComponent.entity

            if let nukeComponent = nexus.getComponent(of: NukePowerupComponent.self, for: entity) {
                updateNukeComponent(nukeComponent, for: deltaTime)
            }
        }
    }

    // Updates the nuke component.
    // At every timestep, its explosion radius should expand and it should destroy enemies that it comes into
    // contact with.
    // Destruction of enemies is handled in PhysicsSystem as it is triggered upon collision.
    private func updateNukeComponent(_ nukeComponent: NukePowerupComponent, for deltaTime: CGFloat) {
        let entity = nukeComponent.entity

        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity),
              let renderableComponent = nexus.getComponent(of: RenderableComponent.self, for: entity) else {
            return
        }

        if nukeComponent.hasCompletedExplosion {
            nexus.removeEntity(entity)
        } else {
            let timeFraction = deltaTime / Constants.nukeExplosionDuration
            let deltaRadius = (Constants.nukeExplosionRadius - (Constants.powerupDiameter / 2)) * timeFraction

            nukeComponent.currentExplosionRadius += deltaRadius
            physicsComponent.physicsBody.size += deltaRadius
            renderableComponent.size += deltaRadius
            renderableComponent.opacity -= timeFraction
        }
    }
}
