import CoreGraphics

class RightMovementDecorator: Movement {
    private let movement: Movement

    init(movement: Movement) {
        self.movement = movement
    }

    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        guard let entityPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
                return
            }

        let entityPhysicsBody = entityPhysicsComponent.physicsBody
        entityPhysicsBody.velocity = .right * Constants.enemyMovementSpeed
        movement.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
    }
}
