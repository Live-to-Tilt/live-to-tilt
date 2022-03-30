import Foundation
import CoreGraphics

class CircleWave: Wave {
    func coroutine(nexus: Nexus) {
        guard
            let playerEntity = nexus.getEntity(with: PlayerComponent.self),
            let playerPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: playerEntity) else {
            return
        }

        let playerPhysicsBody = playerPhysicsComponent.physicsBody
        let playerPosition = playerPhysicsBody.position
        let angle: CGFloat = 2 * .pi / CGFloat(Constants.circleWaveEnemyCount)
        var currentAngle: CGFloat = .zero

        for _ in 0..<Constants.circleWaveEnemyCount {
            let spawnLocation = getEnemySpawnPosition(angle: currentAngle, playerPosition: playerPosition)
            if isEnemyWithinBounds(at: spawnLocation) {
                spawnEnemy(nexus: nexus, target: playerEntity, spawnLocation: spawnLocation)
            }
            currentAngle += angle
        }
    }

    private func spawnEnemy(nexus: Nexus, target playerEntity: Entity, spawnLocation: CGPoint) {
        let movement = HomingMovement(target: playerEntity)
        nexus.createEnemy(position: spawnLocation, movement: movement)
    }

    private func getEnemySpawnPosition(angle: CGFloat, playerPosition: CGPoint) -> CGPoint {
        let x = playerPosition.x + cos(angle) * Constants.circleWaveDistance
        let y = playerPosition.y + sin(angle) * Constants.circleWaveDistance
        let position = CGPoint(x: x, y: y)
        return position
    }

    private func isEnemyWithinBounds(at position: CGPoint) -> Bool {
        let minX = Constants.enemyDiameter / 2
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio - minX

        let minY = Constants.enemyDiameter / 2
        let maxY = Constants.gameArenaHeight - minY

        return position.x >= minX && position.x <= maxX &&
                position.y >= minY && position.y <= maxY
    }
}
