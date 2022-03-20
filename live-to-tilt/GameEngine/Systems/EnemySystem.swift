import CoreGraphics

final class EnemySystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let enemyComponents = nexus.getComponents(of: EnemyComponent.self)
        enemyComponents.forEach { enemyComponent in
            let entity = enemyComponent.entity
            let movement = enemyComponent.movement
            movement.update(entity: entity, deltaTime: deltaTime )
        }
    }
}
