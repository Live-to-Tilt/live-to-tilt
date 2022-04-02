import CoreGraphics

class StraightWave: Wave {
    func coroutine(nexus: Nexus) {
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio - Constants.enemyDiameter / 2
        let maxEnemyCount = Int((Constants.gameArenaHeight / Constants.enemyDiameter).rounded(.down))
        let powerupIndex = Int.random(in: 0..<maxEnemyCount)
        var spawnY = Constants.enemyDiameter / 2
        for i in  0..<maxEnemyCount {
            if i == powerupIndex {
                spawnCheckpoint()
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

    private func spawnCheckpoint() {

    }

    private func spawnEnemy(at position: CGPoint, nexus: Nexus) {
        var movement: Movement = BaseMovement()
        movement = DirectionalMovementDecorator(movement: movement, direction: .left)
        nexus.createEnemy(position: position, movement: movement)
    }
}
