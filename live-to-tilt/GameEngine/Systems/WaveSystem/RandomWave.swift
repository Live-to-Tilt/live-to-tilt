import Foundation
import CoreGraphics

class RandomWave: Wave {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func start() {
        var delay: Double = 0
        for _ in 0..<Constants.randomWaveEnemyCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.spawnEnemy()
            }
            delay += Constants.randomWaveDelay
        }
    }

    private func spawnEnemy() {
        let spawnLocation = getEnemySpawnLocation()
        nexus.createEnemy(position: spawnLocation)
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
