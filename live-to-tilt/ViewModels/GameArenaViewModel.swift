import Combine

class GameArenaViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent]
    @Published var gameStateComponent: GameStateComponent?
    @Published var comboComponent: ComboComponent?
    @Published var countdownComponent: CountdownComponent?
    @Published var achievement: Achievement?
    @Published var showAchievement = false

    var gameEngine: GameEngine
    var gameControl: GameControl
    var gameRenderer: GameRenderer
    var achievementManager: AchievementManager

    var cancellables = Set<AnyCancellable>()

    init(gameMode: GameMode) {
        renderableComponents = []
        gameEngine = GameEngine(gameMode: gameMode)
        gameControl = GameControlManager.shared.gameControl
        gameRenderer = GameRenderer(gameEngine: gameEngine, gameControl: gameControl)
        achievementManager = AchievementManager()
        gameRenderer.start()
        attachPublishers()
    }

    deinit {
        gameRenderer.stop()
    }

    func restart() {
        detachPublishers()
        gameRenderer.stop()
        gameEngine = GameEngine(gameMode: gameEngine.gameMode)
        gameRenderer = GameRenderer(gameEngine: gameEngine, gameControl: gameControl)
        achievementManager.reinit()
        gameRenderer.start()
        attachPublishers()
    }

    func pause() {
        gameRenderer.pause()
    }

    func resume() {
        gameRenderer.unpause()
    }

    private func attachPublishers() {
        gameEngine.renderablePublisher.sink { [weak self] renderableComponents in
            self?.renderableComponents = renderableComponents
        }.store(in: &cancellables)

        gameEngine.gameStatePublisher.sink { [weak self] gameStateComponent in
            self?.gameStateComponent = gameStateComponent
            self?.updateGameRenderer()
        }.store(in: &cancellables)

        gameEngine.comboPublisher.sink { [weak self] comboComponent in
            self?.comboComponent = comboComponent
        }.store(in: &cancellables)

        gameEngine.countdownSubject.sink { [weak self] countdownComponent in
            self?.countdownComponent = countdownComponent
        }.store(in: &cancellables)

        achievementManager.$newAchievement.sink { [weak self] newAchievement in
            guard let achievement = newAchievement else {
                return
            }
            self?.achievement = achievement
            self?.showAchievement = true
        }.store(in: &cancellables)
    }

    private func detachPublishers() {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables = []
    }

    private func updateGameRenderer() {
        switch gameStateComponent?.state {
        case .gameOver:
            gameRenderer.stop()
        default:
            break
        }
    }
}
