import CoreGraphics
import Combine

class GameEngine {
    // ECS
    let nexus = Nexus()
    let systems: [System]
    let physicsWorld = PhysicsWorld()

    let renderableSubject = PassthroughSubject<[RenderableComponent], Never>()
    var renderablePublisher: AnyPublisher<[RenderableComponent], Never> {
        renderableSubject.eraseToAnyPublisher()
    }

    let gameStateSubject = PassthroughSubject<GameStateComponent, Never>()
    var gameStatePublisher: AnyPublisher<GameStateComponent, Never> {
        gameStateSubject.eraseToAnyPublisher()
    }

    init() {
        systems = [
            PhysicsSystem(nexus: nexus, physicsWorld: physicsWorld),
            CollisionSystem(nexus: nexus, physicsWorld: physicsWorld),
            PlayerSystem(nexus: nexus),
            WaveSystem(nexus: nexus),
            MovementSystem(nexus: nexus),
            PowerupSystem(nexus: nexus),
            EnemySystem(nexus: nexus)
        ]

        setUpEntities()
        EventManager.postEvent(.gameStart)
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        updatePlayer(inputForce: inputForce)
        updateSystems(deltaTime: deltaTime)
        publishRenderables()
        publishGameState()
    }

    func lateUpdate(deltaTime: CGFloat) {
        systems.forEach { $0.lateUpdate(deltaTime: deltaTime) }
    }

    private func setUpEntities() {
        nexus.createWalls()
        nexus.createPlayer()
        nexus.createGameState()
    }

    private func updateSystems(deltaTime: CGFloat) {
        systems.forEach { $0.update(deltaTime: deltaTime) }
    }

    private func updatePlayer(inputForce: CGVector) {
        let playerComponent = nexus.getComponent(of: PlayerComponent.self)
        playerComponent?.inputForce = inputForce
    }

    private func publishRenderables() {
        renderableSubject.send(nexus.getComponents(of: RenderableComponent.self))
    }

    private func publishGameState() {
        guard let gameStateComponent = nexus.getComponent(of: GameStateComponent.self) else {
            return
        }

        gameStateSubject.send(gameStateComponent)
    }
}
