import Combine

class MultiplayerGameArenaViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent]
    @Published var gameStateComponent: GameStateComponent?

    var roomManager: RoomManager
    var gameEngine: GameEngine?
    var gameControl: GameControl
    var gameRenderer: GameRenderer

    var cancellables = Set<AnyCancellable>()

    init(roomManager: RoomManager) {
        self.renderableComponents = []
        self.roomManager = roomManager
        self.gameControl = GameControlManager.shared.gameControl

        if roomManager.isHost {
            let gameEngine = GameEngine(gameMode: .survival)
            self.gameEngine = gameEngine
            self.gameRenderer = MultiplayerHostGameRenderer(roomManager: roomManager,
                                                            gameEngine: gameEngine,
                                                            gameControl: gameControl)
        } else {
            self.gameRenderer = MultiplayerGuestGameRenderer(roomManager: roomManager,
                                                             gameControl: gameControl)
        }

        attachPublishers()
        gameRenderer.start()
    }

    private func attachPublishers() {
        gameEngine?.renderablePublisher.sink { [weak self] renderableComponents in
            self?.renderableComponents = renderableComponents

            let message = HostMessage(renderableComponents: renderableComponents)
            self?.roomManager.send(message: message)
        }.store(in: &cancellables)

        if let guestGameRenderer = gameRenderer as? MultiplayerGuestGameRenderer {
            guestGameRenderer.renderableSubject.sink { [weak self] renderableComponents in
                self?.renderableComponents = renderableComponents
            }.store(in: &cancellables)
        }
    }
}
