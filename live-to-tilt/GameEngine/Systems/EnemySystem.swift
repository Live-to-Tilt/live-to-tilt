import CoreGraphics

class EnemySystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let enemyComponents = nexus.getComponents(of: EnemyComponent.self)

        enemyComponents.forEach { enemyComponent in
            despawnIfOutsideArena(enemyComponent)
            handleCollisions(enemyComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

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

    private func handleCollisions(_ enemyComponent: EnemyComponent) {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: enemyComponent.entity)

        collisionComponents.forEach { collisionComponent in
            handlePlayerCollision(enemyComponent, collisionComponent)
        }
    }

    private func handlePlayerCollision(_ enemyComponent: EnemyComponent, _ collisionComponent: CollisionComponent) {
        let collidedEntity = collisionComponent.collidedEntity
        if !nexus.hasComponent(PlayerComponent.self, in: collidedEntity) {
            return
        }

        if isRecentlySpawned(enemyComponent) {
            return
        }

        endGame()
    }

    private func isRecentlySpawned(_ enemyComponent: EnemyComponent) -> Bool {
        guard let lifespanComponent = nexus.getComponent(of: LifespanComponent.self, for: enemyComponent.entity) else {
            return false
        }
        return lifespanComponent.elapsedTimeSinceSpawn < Constants.enemySpawnDelay
    }

    private func endGame() {
        let gameStateComponent = nexus.getComponent(of: GameStateComponent.self)
        gameStateComponent?.state = .gameOver
    }
}
