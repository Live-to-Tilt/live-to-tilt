import CoreGraphics

class DirectionalMovement: Movement {
    private let movement: Movement
    private let direction: CGVector

    init(movement: Movement, direction: CGVector) {
        self.movement = movement
        self.direction = direction
    }

    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        guard let entityPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
                return
            }

        let entityPhysicsBody = entityPhysicsComponent.physicsBody
        entityPhysicsBody.velocity = direction * Constants.enemyMovementSpeed
        movement.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
    }
}
