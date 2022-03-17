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
            WaveSystem(nexus: nexus),
            EnemySystem(nexus: nexus)
        ]

        setUpEntities()
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        updatePhysicsBodies(deltaTime: deltaTime)
        updatePlayer(inputForce: inputForce)
        updateSystems(deltaTime: deltaTime)
        publishRenderables()
    }

    private func setUpEntities() {
        nexus.createPlayer()
    }

    private func updatePhysicsBodies(deltaTime: CGFloat) {
        let physicsBodies = nexus.getComponents(of: PhysicsComponent.self).map { $0.physicsBody }
        physicsWorld.update(physicsBodies, deltaTime: deltaTime)
    }

    private func updatePlayer(inputForce: CGVector) {
        guard let playerComponent = nexus.getComponents(of: PlayerComponent.self).first else {
            return
        }
        playerComponent.inputForce = inputForce
    }

    private func updateSystems(deltaTime: CGFloat) {
        systems.forEach { $0.update(deltaTime: deltaTime) }
    }

    private func publishRenderables() {
        renderableSubject.send(nexus.getComponents(of: RenderableComponent.self))
    }
}
