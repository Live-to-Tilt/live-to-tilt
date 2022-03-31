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
}
