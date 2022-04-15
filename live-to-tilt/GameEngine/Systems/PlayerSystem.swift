import CoreGraphics

final class PlayerSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let playerComponents = nexus.getComponents(of: PlayerComponent.self)

        playerComponents.forEach { playerComponent in
            applyInputForce(playerComponent, deltaTime: deltaTime)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func applyInputForce(_ playerComponent: PlayerComponent, deltaTime: CGFloat) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: playerComponent.entity) else {
            return
        }

        physicsComponent.physicsBody.velocity = playerComponent.inputForce

        let newRotation = lerpRotation(initialRotation: physicsComponent.physicsBody.rotation,
                                       desiredRotation: playerComponent.inputForce.angle)
        physicsComponent.physicsBody.rotation = newRotation

        let deltaDistance = Float(playerComponent.inputForce.magnitude * deltaTime)
        EventManager.shared.postEvent(PlayerMovedEvent(deltaDistance: deltaDistance))
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
}
