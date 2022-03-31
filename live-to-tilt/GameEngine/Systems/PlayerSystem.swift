import CoreGraphics

class PlayerSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let playerComponents = nexus.getComponents(of: PlayerComponent.self)

        playerComponents.forEach { playerComponent in
            applyInputForce(playerComponent, deltaTime: deltaTime)
            handleCollisions(playerComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func applyInputForce(_ playerComponent: PlayerComponent, deltaTime: CGFloat) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: playerComponent.entity) else {
            return
        }

        // TODO: remove below
        playerComponent.inputForce = CGVector(dx: 0.3, dy: 0.4)
        physicsComponent.physicsBody.velocity = playerComponent.inputForce
        EventManager.shared.postEvent(.playerMoved,
                                      eventInfo: [.distance: Int(playerComponent.inputForce.magnitude * deltaTime)])

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

    private func handleCollisions(_ playerComponent: PlayerComponent) {
        let collisionComponents = nexus.getComponents(of: CollisionComponent.self, for: playerComponent.entity)

        collisionComponents.forEach { collisionComponent in
            handleEnemyCollision(collisionComponent)
        }
    }

    private func handleEnemyCollision(_ collisionComponent: CollisionComponent) {
        guard nexus.getComponent(of: EnemyComponent.self, for: collisionComponent.collidedEntity) != nil else {
            return
        }

        let gameStateComponent = nexus.getComponent(of: GameStateComponent.self)
        // TODO: Remove comment
        // gameStateComponent?.state = .gameOver
    }
}
