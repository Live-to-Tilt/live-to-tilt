import CoreGraphics

final class PowerupSystem: System {
    let nexus: Nexus
    private var elapsedTime: CGFloat = 0
    private var numberOfPowerupsInArena: Int = 0

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        self.elapsedTime += deltaTime

        if self.elapsedTime > Constants.powerupSpawnInterval {
            resetElapsedTime()
            spawnPowerup()
        }
    }

    private func resetElapsedTime() {
        elapsedTime.formTruncatingRemainder(dividingBy: Constants.powerupSpawnInterval)
    }

    private func spawnPowerup() {
        guard numberOfPowerupsInArena < Constants.maxNumberOfPowerupsInArena else {
            return
        }

        let spawnLocation = getPowerupSpawnLocation()
        nexus.createPowerup(position: spawnLocation)

        numberOfPowerupsInArena += 1
    }

    private func getPowerupSpawnLocation() -> CGPoint {
        let minX = Constants.powerupDiameter / 2
        let maxX = Constants.aspectRatio - minX
        let x = CGFloat.random(in: minX...maxX)

        let minY = Constants.enemyDiameter / 2
        let maxY = 1 - minY
        let y = CGFloat.random(in: minY...maxY)

        let position = CGPoint(x: x, y: y)

        return position
    }
}
