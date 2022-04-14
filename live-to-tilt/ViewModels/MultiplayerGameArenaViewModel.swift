import Combine
import Foundation

class MultiplayerGameArenaViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent]
    @Published var gameStateComponent: GameStateComponent?

    var roomManager: RoomManager
    var gameControl: GameControl
    var gameRenderer: GameRenderer
    var gameEngine: GameEngine?

    var cancellables = Set<AnyCancellable>()

    init(roomManager: RoomManager) {
        self.renderableComponents = []
        self.roomManager = roomManager
        self.gameControl = GameControlManager.shared.gameControl

        if roomManager.isHost {
            let gameEngine = GameEngine(gameMode: .survival)
            self.gameEngine = gameEngine
            self.gameRenderer = MultiplayerHostGameRenderer(gameEngine: gameEngine,
                                                            gameControl: gameControl)
        } else {
            self.gameRenderer = MultiplayerGuestGameRenderer(roomManager: roomManager,
                                                             gameControl: gameControl)
        }

        attachPublishers()
        gameRenderer.start()
    }

    private func attachPublishers() {
        if roomManager.isHost {
            let messageHandlerDelegate = GuestMessageHandlerDelegate()
            roomManager.subscribe(messageHandler: messageHandlerDelegate)

            gameEngine?.renderablePublisher.sink { [weak self] renderableComponents in
                self?.renderableComponents = renderableComponents

                let message = HostMessage(renderableComponents: renderableComponents)
                self?.roomManager.send(message: message)
            }.store(in: &cancellables)
        } else {
            let messageHandlerDelegate = HostMessageHandlerDelegate()
            roomManager.subscribe(messageHandler: messageHandlerDelegate)

            messageHandlerDelegate.renderablePublisher.sink { [weak self] renderableComponents in
                self?.renderableComponents = renderableComponents
            }.store(in: &cancellables)
        }
    }
}
