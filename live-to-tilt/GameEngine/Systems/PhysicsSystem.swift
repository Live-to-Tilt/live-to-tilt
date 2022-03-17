import CoreGraphics

class PhysicsSystem: System {
    var nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    private func updateRenderable(_ entity: Entity) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
            return
        }

        let renderableComponents = nexus.getComponents(of: RenderableComponent.self, for: entity)

        renderableComponents.forEach { renderableComponent in
            renderableComponent.position = physicsComponent.physicsBody.position
            renderableComponent.rotation = physicsComponent.physicsBody.rotation
        }
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        let entities = nexus.getEntities(with: PhysicsComponent.self)

        entities.forEach { entity in
            updateRenderable(entity)
        }
    }
}
