import CoreGraphics

class PlayerSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    private func applyInputForce(_ playerComponent: PlayerComponent) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: playerComponent.entity) else {
            return
        }

        physicsComponent.physicsBody.velocity = playerComponent.inputForce

        let initialRotation = physicsComponent.physicsBody.rotation
        let desiredRotation = playerComponent.inputForce.angle
        let smoothedRotation = initialRotation + (desiredRotation - initialRotation) * 0.1
        physicsComponent.physicsBody.rotation = smoothedRotation
    }

    func update(deltaTime: CGFloat) {
        let playerComponents = nexus.getComponents(of: PlayerComponent.self)

        playerComponents.forEach { playerComponent in
            applyInputForce(playerComponent)
        }
    }
}
