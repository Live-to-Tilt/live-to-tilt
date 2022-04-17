import CoreGraphics
import Combine

class GameEngine {
    private var timeScale: CGFloat
    private var previousTimeScale: CGFloat

    // ECS
    let nexus = Nexus()
    let systems: [System]
    let physicsWorld = PhysicsWorld()
    let gameMode: GameMode
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
    let comboSubject = PassthroughSubject<ComboComponent, Never>()
    var comboPublisher: AnyPublisher<ComboComponent, Never> {
        comboSubject.eraseToAnyPublisher()
    }
    let countdownSubject = PassthroughSubject<CountdownComponent, Never>()
    var countdownPublisher: AnyPublisher<CountdownComponent, Never> {
        countdownSubject.eraseToAnyPublisher()
    }

    init(gameMode: GameMode) {
        EventManager.shared.reinit()

        self.timeScale = Constants.defaultTimeScale
        self.previousTimeScale = timeScale
        self.systems = [
            MovementSystem(nexus: nexus),
            PhysicsSystem(nexus: nexus, physicsWorld: physicsWorld),
            CollisionSystem(nexus: nexus, physicsWorld: physicsWorld),
            PlayerSystem(nexus: nexus),
            WaveSpawnerSystem(nexus: nexus),
            PowerupSpawnerSystem(nexus: nexus),
            PowerupSystem(nexus: nexus),
            EnemySystem(nexus: nexus),
            ComboSystem(nexus: nexus),
            ScoreSystem(nexus: nexus),
            CountdownSystem(nexus: nexus),
            EnemyKillerSystem(nexus: nexus),
            EnemyFreezerSystem(nexus: nexus),
            LifespanSystem(nexus: nexus),
            AnimationSystem(nexus: nexus),
            FrozenSystem(nexus: nexus),
            ArenaBoundarySystem(nexus: nexus)
        ]
        self.gameMode = gameMode
        self.gameStats = GameStats(gameMode: gameMode)
        setUpEntities()
        EventManager.shared.postEvent(GameStartedEvent())
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        let scaledTime = deltaTime * timeScale

        gameStats.incrementPlayTime(deltaTime: scaledTime)
        updatePlayer(inputForce: inputForce)
        updateSystems(deltaTime: scaledTime)
        publishRenderables()
        publishGameState()
        publishCombo()
        publishCountdown()
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
        previousTimeScale = timeScale
        timeScale = .zero
    }

    func unpause() {
        guard let gameStateComponent = getGameState() else {
            return
        }
        gameStateComponent.state = .play
        timeScale = previousTimeScale
    }

    private func setUpEntities() {
        nexus.createWalls()
        nexus.createPlayers(for: gameMode)
        nexus.createGameState()
        nexus.createCombo()
        nexus.createWaveSpawner(for: gameMode)
        nexus.createPowerupSpawner(for: gameMode)
        nexus.createCountdown(for: gameMode)
    }

    private func updateSystems(deltaTime: CGFloat) {
        systems.forEach { $0.update(deltaTime: deltaTime) }
    }

    private func updatePlayer(inputForce: CGVector) {
        guard getGameState()?.state == .play else {
            return
        }
        let playerComponents = nexus.getComponents(of: PlayerComponent.self)
        let playerOneComponent = playerComponents.first(where: { $0.isHost })
        playerOneComponent?.inputForce = inputForce
    }

    private func publishRenderables() {
        renderableSubject.send(nexus.getComponents(of: RenderableComponent.self))
    }

    private func publishGameState() {
        guard let gameStateComponent = getGameState() else {
            return
        }

        gameStateSubject.send(gameStateComponent)
    }

    private func publishCombo() {
        guard let comboComponent = nexus.getComponent(of: ComboComponent.self) else {
            return
        }

        comboSubject.send(comboComponent)
    }

    private func publishCountdown() {
        guard let countdownComponent = nexus.getComponent(of: CountdownComponent.self) else {
            return
        }

        countdownSubject.send(countdownComponent)
    }

    private func getGameState() -> GameStateComponent? {
        nexus.getComponent(of: GameStateComponent.self)
    }
}
