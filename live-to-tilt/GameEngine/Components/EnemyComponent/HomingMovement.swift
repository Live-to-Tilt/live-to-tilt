import CoreGraphics

class HomingMovement: Movement {
    let nexus: Nexus
    private let target: Entity

    init(nexus: Nexus, target: Entity) {
        self.nexus = nexus
        self.target = target
    }

    func update(entity: Entity, deltaTime: CGFloat) {
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
