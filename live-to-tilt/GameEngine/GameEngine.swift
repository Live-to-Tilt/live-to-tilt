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
        systems = []

        setUpEntities()
    }

    func setUpEntities() {
        nexus.createPlayer()
    }

    func updatePhysicsWorld(deltaTime: CGFloat) {
        let physicsBodies = nexus.getComponents(of: PhysicsComponent.self).map { $0.physicsBody }
        physicsWorld.update(physicsBodies, deltaTime: deltaTime)
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        updatePhysicsWorld(deltaTime: deltaTime)

        systems.forEach { $0.update(deltaTime: deltaTime) }

        // Publish updates
        renderableSubject.send(nexus.getComponents(of: RenderableComponent.self))
    }
}
