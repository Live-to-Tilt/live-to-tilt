import CoreGraphics

final class EnemySystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let enemyComponents = nexus.getComponents(of: EnemyComponent.self)

        enemyComponents.forEach { enemyComponent in
            handleCollisions(enemyComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

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

        if isFrozen(enemyComponent) {
            AudioController.shared.play(.freezeEnemyDeath)
            killEnemy(enemyComponent)
            return
        }

        if isRecentlySpawned(enemyComponent) {
            return
        }

        endGame()
    }

    private func isFrozen(_ enemyComponent: EnemyComponent) -> Bool {
        nexus.hasComponent(FrozenComponent.self, in: enemyComponent.entity)
    }

    private func killEnemy(_ enemyComponent: EnemyComponent) {
        EventManager.shared.postEvent(EnemyKilledEvent())
        nexus.removeEntity(enemyComponent.entity)
    }

    private func isRecentlySpawned(_ enemyComponent: EnemyComponent) -> Bool {
        guard let lifespanComponent = nexus.getComponent(of: LifespanComponent.self, for: enemyComponent.entity) else {
            return false
        }
        return lifespanComponent.elapsedTimeSinceSpawn < Constants.enemySpawnDelay
    }

    private func endGame() {
        endComboEarly()

        let gameStateComponent = nexus.getComponent(of: GameStateComponent.self)
        gameStateComponent?.state = .gameOver
    }

    private func endComboEarly() {
        guard let comboComponent = nexus.getComponent(of: ComboComponent.self) else {
            return
        }

        let comboScore = comboComponent.comboScore
        if comboScore > 0 {
            EventManager.shared.postEvent(ComboExpiredEvent(comboScore: comboScore))
        }
    }
}
