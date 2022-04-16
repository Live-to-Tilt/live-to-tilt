import Combine

class MultiplayerGameArenaViewModel: ObservableObject {
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
            self.gameRenderer = MultiplayerHostGameRenderer(roomManager: roomManager,
                                                            messageManager: messageManager,
                                                            gameEngine: gameEngine,
                                                            gameControl: gameControl)
        } else {
            self.gameRenderer = MultiplayerGuestGameRenderer(roomManager: roomManager,
                                                             messageManager: messageManager,
                                                             gameControl: gameControl)
        }

        attachPublishers()
        gameRenderer.start()
    }

    private func attachPublishers() {
        gameEngine?.renderablePublisher.sink { [weak self] renderableComponents in
            self?.renderableComponents = renderableComponents

            let message = HostMessage(renderableComponents: renderableComponents)
            self?.messageManager.send(message: message)
        }.store(in: &cancellables)

        if let guestGameRenderer = gameRenderer as? MultiplayerGuestGameRenderer {
            guestGameRenderer.renderableSubject.sink { [weak self] renderableComponents in
                self?.renderableComponents = renderableComponents
            }.store(in: &cancellables)
        }
    }
}
