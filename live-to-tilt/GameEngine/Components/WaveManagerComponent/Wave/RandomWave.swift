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
        let spawnPosition = GameUtils.generateRandomSpawnPosition(forEntityOfWidth: Constants.enemyDiameter,
                                                                  height: Constants.enemyDiameter)
        let movementA: Movement = BaseMovement()
        var movementB: Movement = BaseMovement()
        movementB = HomingMovementDecorator(movement: movementB, target: playerEntity)
        let movementAB = ConnectedMovement(movementA, for: Constants.enemySpawnDelay, then: movementB)
        nexus.createEnemy(position: spawnPosition, movement: movementAB)
    }
}
