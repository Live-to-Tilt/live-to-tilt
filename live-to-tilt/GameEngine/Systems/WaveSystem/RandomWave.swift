import Foundation
import CoreGraphics

class RandomWave: Wave {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func coroutine() {
        guard let playerEntity = nexus.getEntities(with: PlayerComponent.self).first else {
            return
        }

        let startTime: DispatchTime = .now()
        var delay: Double = .zero
        for _ in 0..<Constants.randomWaveEnemyCount {
            DispatchQueue.main.asyncAfter(deadline: startTime + delay) {
                self.spawnEnemy(target: playerEntity)
            }
            delay += Constants.randomWaveDelay
        }
    }

    private func spawnEnemy(target playerEntity: Entity) {
        let spawnLocation = getEnemySpawnLocation()
        var movement: Movement = BaseMovement(nexus: nexus)
        movement = HomingMovementDecorator(target: playerEntity, movement: movement)
        nexus.createEnemy(position: spawnLocation, movement: movement)
    }

    private func getEnemySpawnLocation() -> CGPoint {
        let minX = Constants.enemyDiameter / 2
        let maxX = Constants.aspectRatio - minX
        let x = CGFloat.random(in: minX...maxX)

        let minY = Constants.enemyDiameter / 2
        let maxY = 1 - minY
        let y = CGFloat.random(in: minY...maxY)

        let position = CGPoint(x: x, y: y)

        return position
    }
}
