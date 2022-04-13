import CoreGraphics

class GauntletStraightWave: Wave {
    func coroutine(nexus: Nexus) {
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio
        let maxEnemyCount = Int((Constants.gameArenaHeight / Constants.enemyDiameter).rounded(.down))
        let powerupIndex = Int.random(in: 0..<maxEnemyCount)
        var spawnY = Constants.enemyDiameter / 2

        for i in  0..<maxEnemyCount {
            if i == powerupIndex {
                let spawnPosition = CGPoint(x: maxX, y: spawnY)
                spawnCheckpoint(at: spawnPosition, nexus: nexus)
            } else if !isWithinRange(of: powerupIndex, index: i) {
                let spawnPosition = CGPoint(x: maxX, y: spawnY)
                spawnEnemy(at: spawnPosition, nexus: nexus)
            }
            spawnY += Constants.enemyDiameter
        }
    }

    private func isWithinRange(of powerupIndex: Int, index: Int) -> Bool {
        abs(index - powerupIndex) <= Constants.gauntletStraightWaveGap
    }

    private func spawnCheckpoint(at position: CGPoint, nexus: Nexus) {
        var movement: Movement = BaseMovement()
        movement = DirectionalMovementDecorator(movement: movement, direction: .left)
        nexus.createPowerup(position: position,
                            powerup: TimePowerup(),
                            collisionBitmask: Constants.gauntletOrbCollisionBitmask,
                            movement: movement,
                            despawnOutsideArena: true)
    }

    private func spawnEnemy(at position: CGPoint, nexus: Nexus) {
        var movement: Movement = BaseMovement()
        movement = DirectionalMovementDecorator(movement: movement, direction: .left)
        nexus.createEnemy(position: position, movement: movement, despawnOutsideArena: true)
    }
}
