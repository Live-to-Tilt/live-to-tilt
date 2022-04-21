import Foundation
import CoreGraphics

class RandomWave: Wave {
    func coroutine(nexus: Nexus) {
        let startTime: DispatchTime = .now()
        var delay: Double = .zero
        for _ in 0..<Constants.randomWaveEnemyCount {
            DispatchQueue.main.asyncAfter(deadline: startTime + delay) {
                self.spawnEnemy(nexus: nexus)
            }
            delay += Constants.randomWaveDelay
        }
    }

    private func spawnEnemy(nexus: Nexus) {
        let spawnPosition = GameUtils.generateRandomSpawnPosition(forEntityOfWidth: Constants.enemyDiameter,
                                                                  height: Constants.enemyDiameter)
        guard let playerEntity = getNearestPlayerEntity(from: spawnPosition, nexus: nexus) else {
            return
        }
        let movementA: Movement = BaseMovement()
        var movementB: Movement = BaseMovement()
        movementB = HomingMovementDecorator(movement: movementB, target: playerEntity)
        let movementAB = ConnectedMovement(movementA, for: Constants.enemySpawnDelay, then: movementB)
        nexus.createEnemy(position: spawnPosition, movement: movementAB)
    }

    private func getNearestPlayerEntity(from position: CGPoint, nexus: Nexus) -> Entity? {
        let playerComponents = nexus.getComponents(of: PlayerComponent.self)
        guard
            let currNearestPlayerComponent = playerComponents.first,
            let currNearestPlayerPosition = getPosition(of: currNearestPlayerComponent.entity, nexus: nexus) else {
                return nil
        }

        var currNearestPlayerEntity = currNearestPlayerComponent.entity
        var currMinimumDistance = (position - currNearestPlayerPosition).magnitudeSquared

        for playerComponent in playerComponents {
            let playerEntity = playerComponent.entity
            guard let playerPosition = getPosition(of: playerEntity, nexus: nexus) else {
                continue
            }
            let distance = (position - playerPosition).magnitudeSquared
            if distance < currMinimumDistance {
                currMinimumDistance = distance
                currNearestPlayerEntity = playerEntity
            }
        }

        return currNearestPlayerEntity
    }

    private func getPosition(of entity: Entity, nexus: Nexus) -> CGPoint? {
        let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity)
        let phyiscsBody = physicsComponent?.physicsBody
        let position = phyiscsBody?.position
        return position
    }
}
