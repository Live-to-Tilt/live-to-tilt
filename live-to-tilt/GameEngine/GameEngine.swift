import CoreGraphics
import Combine
import SwiftUI

class GameEngine {
    private var timeScale: CGFloat
    private var previousTimeScale: CGFloat

    @ObservedObject var achievementManager: AchievementManager

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
    let achievementSubject = PassthroughSubject<StatsAchievement, Never>()
    var achievementPublisher: AnyPublisher<StatsAchievement, Never> {
        achievementSubject.eraseToAnyPublisher()
    }
    var achievementCancellable: AnyCancellable?

    init(gameMode: GameMode) {
        EventManager.shared.reinit()

        self.timeScale = Constants.defaultTimeScale
        self.previousTimeScale = timeScale
        self.systems = [
            MovementSystem(nexus: nexus),
            PhysicsSystem(nexus: nexus, physicsWorld: physicsWorld),
            CollisionSystem(nexus: nexus, physicsWorld: physicsWorld),
            PlayerSystem(nexus: nexus),
            WaveSystem(nexus: nexus),
            PowerupSystem(nexus: nexus),
            EnemySystem(nexus: nexus),
            ComboSystem(nexus: nexus),
            ScoreSystem(nexus: nexus),
            CountdownSystem(nexus: nexus)
        ]
        self.gameMode = gameMode
        self.gameStats = GameStats(gameMode: gameMode)
        self.achievementManager = AchievementManager(gameStats: gameStats)
        self.achievementCancellable = achievementManager.$newAchievement.sink { [weak self] newAchievement in
            guard let achievement = newAchievement else {
                return
            }
            self?.publishAchievements(achievement)
        }

        setUpEntities()
        EventManager.shared.postEvent(.gameStarted)
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        let scaledTime = deltaTime * timeScale

        gameStats.incrementPlayTime(deltaTime: deltaTime)
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
        nexus.createPlayer()
        nexus.createGameState()
        nexus.createCombo()
        nexus.createWaveManager(for: gameMode)
        nexus.createPowerups()
        nexus.createCountdown(for: gameMode)
    }

    private func updateSystems(deltaTime: CGFloat) {
        systems.forEach { $0.update(deltaTime: deltaTime) }
    }

    private func updatePlayer(inputForce: CGVector) {
        guard getGameState()?.state == .play else {
            return
        }
        let playerComponent = nexus.getComponent(of: PlayerComponent.self)
        playerComponent?.inputForce = inputForce
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

    private func publishAchievements(_ achievement: StatsAchievement) {
        achievementManager.newAchievement = nil

        achievementSubject.send(achievement)
    }

    private func getGameState() -> GameStateComponent? {
        nexus.getComponent(of: GameStateComponent.self)
    }
}
