import CoreGraphics

final class MovementSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let movementComponents = nexus.getComponents(of: MovementComponent.self)
        movementComponents.forEach { movementComponent in
            let entity = movementComponent.entity
            let movement = movementComponent.movement
            movement.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {
        let movementEntities = nexus.getEntities(with: MovementComponent.self)
        movementEntities.forEach { entity in
            resetVelocity(for: entity)
        }
    }

    private func resetVelocity(for entity: Entity) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
            return
        }
        let physicsBody = physicsComponent.physicsBody
        physicsBody.velocity = .zero
    }
}
