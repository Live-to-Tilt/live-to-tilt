import CoreGraphics

class HomingMovementDecorator: Movement {
    let nexus: Nexus
    private let target: Entity
    private let movement: Movement

    init(target: Entity, movement: Movement) {
        self.nexus = movement.nexus
        self.target = target
        self.movement = movement
    }

    func update(entity: Entity, deltaTime: CGFloat) {
        movement.update(entity: entity, deltaTime: deltaTime)

        guard
            let entityPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity),
            let targetPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: target) else {
                return
            }

        let entityPhysicsBody = entityPhysicsComponent.physicsBody
        let targetPhysicsBody = targetPhysicsComponent.physicsBody
        let entityPosition = entityPhysicsBody.position
        let targetPosition = targetPhysicsBody.position
        let currentVelocity = entityPhysicsBody.velocity
        let desiredDirection = targetPosition - entityPosition
        let desiredVelocity = desiredDirection.unitVector * Constants.homingMovementVelocity
        let force = desiredVelocity - currentVelocity
        entityPhysicsBody.applyForce(force)
    }
}
