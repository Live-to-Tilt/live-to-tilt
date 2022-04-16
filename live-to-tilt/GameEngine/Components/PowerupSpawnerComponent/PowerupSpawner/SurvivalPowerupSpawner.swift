import CoreGraphics

class SurvivalPowerupSpawner: PowerupSpawner {
    private let nexus: Nexus
    private let powerupIterator: AnyIterator<Powerup>

    init(nexus: Nexus) {
        let powerups: [Powerup] = [
            NukePowerup(),
            LightsaberPowerup(),
            FreezePowerup()
        ]
        self.powerupIterator = powerups.makeRandomIterator()
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let powerupEntities = nexus.getEntities(with: PowerupComponent.self)
        let missingPowerupCount = Constants.survivalPowerupCount - powerupEntities.count
        spawnPowerups(count: missingPowerupCount)
    }

    private func spawnPowerups(count: Int) {
        for _ in 0..<count {
            guard let powerup = powerupIterator.next() else {
                continue
            }

            let spawnPosition = GameUtils.generateRandomSpawnPosition(forEntityOfWidth: Constants.powerupDiameter,
                                                                      height: Constants.powerupDiameter)
            let velocity = CGVector.random(magnitude: Constants.maxPowerupSpeed)
            nexus.createPowerup(position: spawnPosition,
                                powerup: powerup,
                                velocity: velocity,
                                collisionBitmask: Constants.survivalOrbCollisionBitmask)
        }
    }
}
