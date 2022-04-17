import Combine

class SingleplayerGameArenaViewModel: ObservableObject, Pausable {
    @Published var renderableComponents: [RenderableComponent]
    @Published var gameStateComponent: GameStateComponent?
    @Published var comboComponent: ComboComponent?
    @Published var countdownComponent: CountdownComponent?
    @Published var showAchievement = false
    @Published var achievement: Achievement?
    var achievements: [Achievement]

    var gameEngine: GameEngine
    var gameControl: GameControl
    var gameRenderer: GameRenderer
    var achievementManager: AchievementManager

    var cancellables = Set<AnyCancellable>()

    init(gameMode: GameMode) {
        renderableComponents = []
        gameEngine = GameEngine(gameMode: gameMode)
        gameControl = GameControlManager.shared.gameControl
        gameRenderer = SingleplayerGameRenderer(gameEngine: gameEngine, gameControl: gameControl)
        achievementManager = AchievementManager()
        achievements = []

        attachPublishers()
        gameRenderer.start()
    }

    deinit {
        gameRenderer.stop()
    }

    func restart() {
        detachPublishers()
        gameRenderer.stop()
        gameEngine = GameEngine(gameMode: gameEngine.gameMode)
        gameRenderer = SingleplayerGameRenderer(gameEngine: gameEngine, gameControl: gameControl)
        resetAchievements()

        attachPublishers()
        gameRenderer.start()
    }

    func pause() {
        gameRenderer.pause()
    }

    func resume() {
        gameRenderer.unpause()
    }

    func getGameOverStats() -> [GameOverStat] {
        gameEngine.gameStats.getGameOverStats()
    }

    func nextAchievement() {
        if !achievements.isEmpty {
            self.achievement = achievements.removeFirst()
            self.showAchievement = true
        } else {
            self.achievement = nil
            self.showAchievement = false
        }
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
            guard let self = self else {
                return
            }
            let receivedAchievement: Achievement? = newAchievement
            if let rawAchievement = receivedAchievement {
                self.achievements.append(rawAchievement)
            }

            if !self.achievements.isEmpty {
                if self.achievement == nil {
                    self.achievement = self.achievements.removeFirst()
                }
                self.showAchievement = true
            }
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

    private func resetAchievements() {
        achievementManager.reinit()
        achievements = []
        achievement = nil
        showAchievement = false
    }
}
