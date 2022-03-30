import CoreGraphics

class HomingMovementDecorator: Movement {
    private let movement: Movement
    private let target: Entity

    init(movement: Movement, target: Entity) {
        self.movement = movement
        self.target = target
    }

    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        guard
            let entityPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity),
            let targetPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: target) else {
                return
            }

        let entityPhysicsBody = entityPhysicsComponent.physicsBody
        let targetPhysicsBody = targetPhysicsComponent.physicsBody
        let entityPosition = entityPhysicsBody.position
        let targetPosition = targetPhysicsBody.position
        let desiredDirection = targetPosition - entityPosition
        let desiredVelocity = desiredDirection.unitVector * Constants.enemyMovementSpeed
        entityPhysicsBody.velocity += desiredVelocity
        movement.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
    }
}
