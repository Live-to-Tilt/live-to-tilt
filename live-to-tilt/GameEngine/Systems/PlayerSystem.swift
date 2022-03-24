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

        let newRotation = lerpRotation(initialRotation: physicsComponent.physicsBody.rotation,
                                       desiredRotation: playerComponent.inputForce.angle)
        physicsComponent.physicsBody.rotation = newRotation
    }

    private func lerpRotation(initialRotation: CGFloat, desiredRotation: CGFloat) -> CGFloat {
        var difference = desiredRotation - initialRotation
        if difference > .pi {
            difference -= 2 * .pi
        } else if difference < -.pi {
            difference += 2 * .pi
        }

        var smoothedRotation = initialRotation + difference * 0.1
        if smoothedRotation > .pi {
            smoothedRotation -= 2 * .pi
        } else if smoothedRotation < -.pi {
            smoothedRotation = 2 * .pi - smoothedRotation
        }

        return smoothedRotation
    }

    func update(deltaTime: CGFloat) {
        let playerComponents = nexus.getComponents(of: PlayerComponent.self)

        playerComponents.forEach { playerComponent in
            applyInputForce(playerComponent)
        }
    }
}
