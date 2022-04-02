import CoreGraphics

class CopyMovementDecorator: MovementDecorator {
    private let target: Entity

    init(movement: Movement, target: Entity) {
        self.target = target
        super.init(movement: movement)
    }

    override func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        guard
            let entityPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity),
            let targetPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: target) else {
                return
            }

        let entityPhysicsBody = entityPhysicsComponent.physicsBody
        let targetPhysicsBody = targetPhysicsComponent.physicsBody
        entityPhysicsBody.velocity += targetPhysicsBody.velocity
        super.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
    }
}
