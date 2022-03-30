import CoreGraphics

class LeftMovementDecorator: Movement {
    private let movement: Movement

    init(movement: Movement) {
        self.movement = movement
    }

    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        guard let entityPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
                return
            }

        let entityPhysicsBody = entityPhysicsComponent.physicsBody
        entityPhysicsBody.velocity = .left * Constants.enemyMovementSpeed
        movement.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
    }
}
