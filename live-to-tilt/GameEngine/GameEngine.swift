import CoreGraphics
import Combine

class GameEngine {
    // ECS
    let nexus = Nexus()
    let systems: [System]

    let renderableSubject = PassthroughSubject<[RenderableComponent], Never>()
    var renderablePublisher: AnyPublisher<[RenderableComponent], Never> {
        renderableSubject.eraseToAnyPublisher()
    }

    let gameStats: GameStats

    let gameStateSubject = PassthroughSubject<GameStateComponent, Never>()
    var gameStatePublisher: AnyPublisher<GameStateComponent, Never> {
        gameStateSubject.eraseToAnyPublisher()
    }

    init() {
        gameStats = GameStats()
        systems = [
            PhysicsSystem(nexus: nexus),
            PlayerSystem(nexus: nexus),
            WaveSystem(nexus: nexus),
            MovementSystem(nexus: nexus),
            PowerupSystem(nexus: nexus)
        ]

        setUpEntities()
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        updateSystems(deltaTime: deltaTime)
        updatePlayer(inputForce: inputForce)
        publishRenderables()
        publishGameState()
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
