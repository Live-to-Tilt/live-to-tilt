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
        var movement: Movement = BaseMovement()
        movement = HomingMovementDecorator(movement: movement, target: playerEntity)
        nexus.createEnemy(position: spawnLocation, movement: movement)
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
