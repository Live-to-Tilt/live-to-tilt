import CoreGraphics

class SurvivalPowerupManager: PowerupManager {
    private let powerupIterator: AnyIterator<Powerup>

    init() {
        let powerups: [Powerup] = [
            NukePowerup(),
            LightsaberPowerup()
        ]
        self.powerupIterator = powerups.makeRandomIterator()
    }

    func update(nexus: Nexus, deltaTime: CGFloat) {
        let powerupEntites = nexus.getEntities(with: PowerupComponent.self)
        let missingPowerupCount = Constants.survivalPowerupCount - powerupEntites.count
        spawnPowerups(nexus: nexus, count: missingPowerupCount)
    }

    private func spawnPowerups(nexus: Nexus, count: Int) {
        for _ in 0..<count {
            guard let powerup = powerupIterator.next() else {
                continue
            }

            let spawnPosition = GameUtils.generateRandomSpawnPosition(forEntityOfWidth: Constants.powerupDiameter,
                                                                      height: Constants.powerupDiameter)
            let velocity = CGVector.random(magnitude: Constants.maxPowerupSpeed)
            nexus.createPowerup(position: spawnPosition, powerup: powerup, velocity: velocity)
        }
    }
}
