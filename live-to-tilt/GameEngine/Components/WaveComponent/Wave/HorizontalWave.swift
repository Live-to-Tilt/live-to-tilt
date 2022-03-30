import Foundation
import CoreGraphics

class HorizontalWave: Wave {
    func coroutine(nexus: Nexus) {
        guard let playerEntity = nexus.getEntity(with: PlayerComponent.self) else {
            return
        }

        let gap: CGFloat = 1 / CGFloat(Constants.horizontalWaveEnemyCount * 2)
        let arenaWidth = Constants.gameArenaHeight * Constants.gameArenaAspectRatio
        let horizontalMovementDistance = arenaWidth - Constants.enemyDiameter
        let horizontalMovementDuration: CGFloat = horizontalMovementDistance / Constants.enemyMovementSpeed
        var currentHeight: CGFloat = .zero
        for i in 0..<Constants.horizontalWaveEnemyCount {
            currentHeight += gap
            if i.isMultiple(of: 2) {
                spawnLeftMovingEnemy(nexus: nexus,
                                     target: playerEntity,
                                     height: currentHeight,
                                     horizontalMovementDuration: horizontalMovementDuration)
            } else {
                spawnRightMovingEnemy(nexus: nexus,
                                      target: playerEntity,
                                      height: currentHeight,
                                      horizontalMovementDuration: horizontalMovementDuration)
            }
            currentHeight += gap
        }
    }

    private func spawnLeftMovingEnemy(nexus: Nexus,
                                      target playerEntity: Entity,
                                      height: CGFloat,
                                      horizontalMovementDuration: CGFloat) {
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio - Constants.enemyDiameter / 2
        let spawnLocation = CGPoint(x: maxX, y: height)
        var movementA: Movement = BaseMovement()
        movementA = LeftMovementDecorator(movement: movementA)
        var movementB: Movement = BaseMovement()
        movementB = HomingMovementDecorator(movement: movementB, target: playerEntity)
        let movement = ConnectedMovement(movementA, for: horizontalMovementDuration, then: movementB)
        nexus.createEnemy(position: spawnLocation, movement: movement)
    }

    private func spawnRightMovingEnemy(nexus: Nexus,
                                       target playerEntity: Entity,
                                       height: CGFloat,
                                       horizontalMovementDuration: CGFloat) {
        let minX = Constants.enemyDiameter / 2
        let spawnLocation = CGPoint(x: minX, y: height)
        var movementA: Movement = BaseMovement()
        movementA = RightMovementDecorator(movement: movementA)
        var movementB: Movement = BaseMovement()
        movementB = HomingMovementDecorator(movement: movementB, target: playerEntity)
        let movement = ConnectedMovement(movementA, for: horizontalMovementDuration, then: movementB)
        nexus.createEnemy(position: spawnLocation, movement: movement)
    }
}
