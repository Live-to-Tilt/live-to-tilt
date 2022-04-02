import CoreGraphics

class EnemySystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let enemyComponents = nexus.getComponents(of: EnemyComponent.self)

        enemyComponents.forEach { enemyComponent in
            updateElapsedDuration(enemyComponent, deltaTime: deltaTime)
            despawnIfLifespanOver(enemyComponent)
            despawnIfOutsideArena(enemyComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updateElapsedDuration(_ enemyComponent: EnemyComponent, deltaTime: CGFloat) {
        enemyComponent.elapsedDuration += deltaTime
    }

    private func isLifespanOver(_ enemyComponent: EnemyComponent) -> Bool {
        enemyComponent.elapsedDuration > Constants.enemyLifespan
    }

    private func despawnIfLifespanOver(_ enemyComponent: EnemyComponent) {
        if isLifespanOver(enemyComponent) {
            nexus.removeEntity(enemyComponent.entity)
        }
    }

    private func isOutsideArena(_ enemyComponent: EnemyComponent) -> Bool {
        let entity = enemyComponent.entity
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
            return false
        }
        let physicsBody = physicsComponent.physicsBody
        let position = physicsBody.position
        return position.x < Constants.leftWallPosition.x ||
        position.x > Constants.rightWallPosition.x ||
        position.y > Constants.bottomWallPosition.y ||
        position.y < Constants.topWallPosition.y
    }

    private func despawnIfOutsideArena(_ enemyComponent: EnemyComponent) {
        if isOutsideArena(enemyComponent) {
            nexus.removeEntity(enemyComponent.entity)
        }
    }
}
