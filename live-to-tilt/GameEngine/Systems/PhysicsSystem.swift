import CoreGraphics

final class PhysicsSystem: System {
    let nexus: Nexus
    let physicsWorld: PhysicsWorld

    init(nexus: Nexus, physicsWorld: PhysicsWorld) {
        self.nexus = nexus
        self.physicsWorld = physicsWorld
    }

    func update(deltaTime: CGFloat) {
        let entities = nexus.getEntities(with: PhysicsComponent.self)

        entities.forEach { entity in
            updateRenderable(entity)
        }

        updatePhysicsBodies(deltaTime: deltaTime)
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updatePhysicsBodies(deltaTime: CGFloat) {
        let physicsBodies = nexus.getComponents(of: PhysicsComponent.self).map { $0.physicsBody }
        physicsWorld.update(physicsBodies, deltaTime: deltaTime)
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
}
