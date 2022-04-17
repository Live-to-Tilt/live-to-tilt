import Combine

class MultiplayerGameArenaViewModel: GameArenaViewModel {
    @Published var renderableComponents: [RenderableComponent]
    @Published var gameStateComponent: GameStateComponent?

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
        super.init()

        attachPublishers()
        gameRenderer.start()
    }

    deinit {
        gameRenderer.stop()
    }

    override func restart() {
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

    override func pause() {
        gameRenderer.pause()
    }

    override func resume() {
        gameRenderer.unpause()
    }

    override func getGameOverStats() -> [GameOverStat] {
        if roomManager.isHost {
            return gameEngine?.gameStats.getGameOverStats() ?? []
        } else {
            // TODO: receive game over stats from host
            return []
        }
    }

    private func attachPublishers() {
        gameEngine?.renderablePublisher.sink { [weak self] renderableComponents in
            self?.renderableComponents = renderableComponents

            let message = HostMessage(renderableComponents: renderableComponents)
            self?.messageManager.send(message: message)
        }.store(in: &cancellables)

        gameEngine?.gameStatePublisher.sink { [weak self] gameStateComponent in
            self?.gameStateComponent = gameStateComponent
            self?.updateGameRenderer()
        }.store(in: &cancellables)

        if let guestGameRenderer = gameRenderer as? MultiplayerGuestGameRenderer {
            guestGameRenderer.renderableSubject.sink { [weak self] renderableComponents in
                self?.renderableComponents = renderableComponents
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
