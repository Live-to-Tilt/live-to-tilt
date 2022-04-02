import CoreGraphics

class HomingMovementDecorator: MovementDecorator {
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
        let entityPosition = entityPhysicsBody.position
        let targetPosition = targetPhysicsBody.position
        let desiredDirection = targetPosition - entityPosition
        let desiredVelocity = desiredDirection.unitVector * Constants.enemyMovementSpeed
        entityPhysicsBody.velocity += desiredVelocity
        super.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
    }
}
