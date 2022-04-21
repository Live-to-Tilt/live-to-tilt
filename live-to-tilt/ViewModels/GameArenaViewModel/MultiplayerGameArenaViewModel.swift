import Combine

class MultiplayerGameArenaViewModel: ObservableObject, Pausable {
    @Published var renderableComponents: [RenderableComponent]
    @Published var gameStateComponent: GameStateComponent?
    @Published var comboComponent: ComboComponent?
    var gameStats: GameStats?

    var roomManager: RoomManager
    var messageManager: MessageManager

    var gameEngine: GameEngine?
    var gameControl: GameControl
    var gameRenderer: GameRenderer

    var cancellables = Set<AnyCancellable>()

    init(roomManager: RoomManager, messageManager: MessageManager) {
        self.renderableComponents = []
        self.roomManager = roomManager
        self.messageManager = messageManager
        self.gameControl = GameControlManager.shared.gameControl

        if roomManager.isHost {
            let gameEngine = GameEngine(gameMode: .coop)
            self.gameEngine = gameEngine
            self.gameRenderer = MultiplayerHostGameRenderer(messageManager: messageManager,
                                                            gameEngine: gameEngine,
                                                            gameControl: gameControl)
        } else {
            self.gameRenderer = MultiplayerGuestGameRenderer(messageManager: messageManager,
                                                             gameControl: gameControl)
        }

        attachPublishers()
        gameRenderer.start()
    }

    deinit {
        gameRenderer.stop()
    }

    func restart() {
        detachPublishers()
        gameRenderer.stop()
        if roomManager.isHost {
            let gameEngine = GameEngine(gameMode: .coop)
            self.gameEngine = gameEngine
            self.gameRenderer = MultiplayerHostGameRenderer(messageManager: messageManager,
                                                            gameEngine: gameEngine,
                                                            gameControl: gameControl)
        } else {
            self.gameRenderer = MultiplayerGuestGameRenderer(messageManager: messageManager,
                                                             gameControl: gameControl)
        }

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
        gameStats?.getGameOverStats() ?? []
    }

    func getWaveNumber() -> Int {
        gameStats?.wave ?? 0
    }

    func getScore() -> String {
        gameStats?.getBackdropValue() ?? ""
    }

    private func attachPublishers() {
        gameEngine?.renderablePublisher.sink { [weak self] renderableComponents in
            self?.renderableComponents = renderableComponents

            let gameStateComponent = self?.gameStateComponent
            let comboComponent = self?.comboComponent
            let gameStats = self?.gameStats
            let message = HostMessage(gameStateComponent: gameStateComponent,
                                      renderableComponents: renderableComponents,
                                      comboComponent: comboComponent,
                                      gameStats: gameStats)
            self?.messageManager.send(message: message)
        }.store(in: &cancellables)

        gameEngine?.gameStatePublisher.sink { [weak self] gameStateComponent in
            self?.gameStateComponent = gameStateComponent
            self?.updateGameRenderer()
        }.store(in: &cancellables)

        gameEngine?.comboPublisher.sink { [weak self] comboComponent in
            self?.comboComponent = comboComponent
        }.store(in: &cancellables)

        gameEngine?.$gameStats.sink { [weak self] gameStats in
            self?.gameStats = gameStats
        }.store(in: &cancellables)

        if let guestGameRenderer = gameRenderer as? MultiplayerGuestGameRenderer {
            guestGameRenderer.gameStateSubject.sink { [weak self] gameStateComponent in
                self?.gameStateComponent = gameStateComponent
            }.store(in: &cancellables)

            guestGameRenderer.renderableSubject.sink { [weak self] renderableComponents in
                self?.renderableComponents = renderableComponents
            }.store(in: &cancellables)

            guestGameRenderer.comboSubject.sink { [weak self] comboComponent in
                self?.comboComponent = comboComponent
            }.store(in: &cancellables)

            guestGameRenderer.gameStatsSubject.sink { [weak self] gameStats in
                self?.gameStats = gameStats
            }.store(in: &cancellables)
        }
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
