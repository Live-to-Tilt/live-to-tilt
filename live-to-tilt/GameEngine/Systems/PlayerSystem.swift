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

        physicsComponent.physicsBody.applyForce(playerComponent.inputForce)
        physicsComponent.physicsBody.rotation = physicsComponent.physicsBody.velocity.angle + .pi / 2
    }

    func update(deltaTime: CGFloat) {
        let playerComponents = nexus.getComponents(of: PlayerComponent.self)

        playerComponents.forEach { playerComponent in
            applyInputForce(playerComponent)
        }
    }
}
