import CoreGraphics
import Combine

class GameEngine {
    // ECS
    let nexus = Nexus()
    let systems: [System]

    // Physics Engine
    let physicsWorld = PhysicsWorld()

    let renderableSubject = PassthroughSubject<[RenderableComponent], Never>()
    var renderablePublisher: AnyPublisher<[RenderableComponent], Never> {
        renderableSubject.eraseToAnyPublisher()
    }

    init() {
        systems = [
            PhysicsSystem(nexus: nexus),
            PlayerSystem(nexus: nexus),
            WaveSystem(nexus: nexus)
        ]

        setUpEntities()
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        updatePhysicsBodies(deltaTime: deltaTime)
        updateSystems(deltaTime: deltaTime, inputForce: inputForce)
        publishRenderables()
    }

    private func setUpEntities() {
        nexus.createPlayer()
    }

    private func updatePhysicsBodies(deltaTime: CGFloat) {
        let physicsBodies = nexus.getComponents(of: PhysicsComponent.self).map { $0.physicsBody }
        physicsWorld.update(physicsBodies, deltaTime: deltaTime)
    }

    private func updateSystems(deltaTime: CGFloat, inputForce: CGVector) {
        systems.forEach { $0.update(deltaTime: deltaTime, inputForce: inputForce) }
    }

    private func publishRenderables() {
        renderableSubject.send(nexus.getComponents(of: RenderableComponent.self))
    }
}
