import Foundation
import CoreGraphics

class RandomWave: Wave {
    func coroutine(nexus: Nexus) {
        guard let playerEntity = nexus.getEntity(with: PlayerComponent.self) else {
            return
        }

        let startTime: DispatchTime = .now()
        var delay: Double = .zero
        for _ in 0..<Constants.randomWaveEnemyCount {
            DispatchQueue.main.asyncAfter(deadline: startTime + delay) {
                self.spawnEnemy(nexus: nexus, target: playerEntity)
            }
            delay += Constants.randomWaveDelay
        }
    }

    private func spawnEnemy(nexus: Nexus, target playerEntity: Entity) {
        let spawnLocation = getEnemySpawnLocation()
        let movementA: Movement = BaseMovement()
        var movementB: Movement = BaseMovement()
        movementB = HomingMovementDecorator(movement: movementB, target: playerEntity)
        let movementAB = ConnectedMovement(movementA, for: Constants.enemySpawnDelay, then: movementB)
        nexus.createEnemy(position: spawnLocation, movement: movementAB)
    }

    private func getEnemySpawnLocation() -> CGPoint {
        let minX = Constants.enemyDiameter / 2
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio - minX
        let x = CGFloat.random(in: minX...maxX)

        let minY = Constants.enemyDiameter / 2
        let maxY = Constants.gameArenaHeight - minY
        let y = CGFloat.random(in: minY...maxY)

        let position = CGPoint(x: x, y: y)

        return position
    }
}
