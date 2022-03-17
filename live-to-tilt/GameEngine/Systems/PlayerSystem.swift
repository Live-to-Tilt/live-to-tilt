import CoreGraphics

class PlayerSystem: System {
    var nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    private func applyInputForce(_ entity: Entity, _ inputForce: CGVector) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
            return
        }

        physicsComponent.physicsBody.applyForce(inputForce)
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        let entites = nexus.getEntities(with: PlayerComponent.self)

        entites.forEach { entity in
            applyInputForce(entity, inputForce)
        }
    }
}
