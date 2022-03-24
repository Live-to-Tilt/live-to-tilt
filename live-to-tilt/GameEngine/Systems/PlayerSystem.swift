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
        physicsComponent.physicsBody.rotation = smoothedRotation
    }

    func update(deltaTime: CGFloat) {
        let playerComponents = nexus.getComponents(of: PlayerComponent.self)

        playerComponents.forEach { playerComponent in
            applyInputForce(playerComponent)
        }
    }
}
