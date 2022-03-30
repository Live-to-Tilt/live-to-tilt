import CoreGraphics
import Combine

class GameEngine {
    private var timeScale: CGFloat
    private var origTimeScale: CGFloat

    // ECS
    let nexus = Nexus()
    let systems: [System]
    let physicsWorld = PhysicsWorld()
    let gameStats: GameStats

    // Publishers
    let renderableSubject = PassthroughSubject<[RenderableComponent], Never>()
    var renderablePublisher: AnyPublisher<[RenderableComponent], Never> {
        renderableSubject.eraseToAnyPublisher()
    }
    let gameStateSubject = PassthroughSubject<GameStateComponent, Never>()
    var gameStatePublisher: AnyPublisher<GameStateComponent, Never> {
        gameStateSubject.eraseToAnyPublisher()
    }

    init(timeScale: CGFloat = Constants.defaultTimeScale) {
        EventManager.shared.reinit()

        self.timeScale = timeScale
        self.origTimeScale = timeScale
        systems = [
            MovementSystem(nexus: nexus),
            PhysicsSystem(nexus: nexus, physicsWorld: physicsWorld),
            CollisionSystem(nexus: nexus, physicsWorld: physicsWorld),
            PlayerSystem(nexus: nexus),
            WaveSystem(nexus: nexus),
            PowerupSystem(nexus: nexus),
            EnemySystem(nexus: nexus)
        ]
        gameStats = GameStats()

        setUpEntities()
        EventManager.shared.postEvent(.gameStarted)
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        let scaledTime = deltaTime * timeScale

        if getGameState()?.state == .play {
            updatePlayer(inputForce: inputForce)
        }
        updateSystems(deltaTime: scaledTime)
        publishRenderables()
        publishGameState()
    }

    func lateUpdate(deltaTime: CGFloat) {
        let scaledTime = deltaTime * timeScale
        systems.forEach { $0.lateUpdate(deltaTime: scaledTime) }
    }

    func pause() {
        guard let gameStateComponent = getGameState() else {
            return
        }
        gameStateComponent.state = .pause
        timeScale = .zero
    }

    func unpause() {
        guard let gameStateComponent = getGameState() else {
            return
        }
        gameStateComponent.state = .play
        timeScale = origTimeScale
    }

    private func setUpEntities() {
        nexus.createWalls()
        nexus.createPlayer()
        nexus.createGameState()
        nexus.createWave()
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

    private func getGameState() -> GameStateComponent? {
        nexus.getComponent(of: GameStateComponent.self)
    }
}
