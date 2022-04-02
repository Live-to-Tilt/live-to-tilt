import CoreGraphics

class DirectionalMovementDecorator: MovementDecorator {
    private let direction: CGVector

    init(movement: Movement, direction: CGVector) {
        self.direction = direction
        super.init(movement: movement)
    }

    override func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        guard let entityPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
                return
        }

        let entityPhysicsBody = entityPhysicsComponent.physicsBody
        entityPhysicsBody.velocity += direction * Constants.enemyMovementSpeed
        super.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
    }
}
