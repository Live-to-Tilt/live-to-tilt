import CoreGraphics

class StraightWave: Wave {
    private let start: CGPoint
    private let end: CGPoint

    init(from start: CGPoint, to end: CGPoint) {
        self.start = start
        self.end = end
    }

    func coroutine(nexus: Nexus) {
        let distance = start.distanceTo(end)
        let maxEnemyCount = Int((distance / Constants.enemyDiameter).rounded(.down))
        var spawnX = start.x + Constants.enemyDiameter / 2
        var spawnY = start.y + Constants.enemyDiameter / 2

        guard maxEnemyCount != 0 else {
            return
        }

        let deltaX = (end.x - start.x) / CGFloat(maxEnemyCount)
        let deltaY = (end.y - start.y) / CGFloat(maxEnemyCount)

        for _ in  0..<maxEnemyCount {
            let spawnPosition = CGPoint(x: spawnX, y: spawnY)
            spawnEnemy(at: spawnPosition, nexus: nexus)
            spawnX += deltaX
            spawnY += deltaY
        }
    }

    private func spawnEnemy(at position: CGPoint, nexus: Nexus) {
        var movement: Movement = BaseMovement()
        movement = DirectionalMovementDecorator(movement: movement, direction: .left)
        nexus.createEnemy(position: position, movement: movement, despawnOutsideArena: true)
    }
}
