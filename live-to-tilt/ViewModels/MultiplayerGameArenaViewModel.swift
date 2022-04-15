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

            let messageDelegate = GuestMessageDelegate()
            roomManager.subscribe(messageDelegate: messageDelegate)
        } else {
            let messageBuffer = MessageBuffer()
            let gameRenderer = MultiplayerGuestGameRenderer(roomManager: roomManager,
                                                            messageBuffer: messageBuffer,
                                                            gameControl: gameControl)
            self.gameRenderer = gameRenderer

            gameRenderer.renderablePublisher.sink { [weak self] renderableComponents in
                self?.renderableComponents = renderableComponents
            }.store(in: &cancellables)

            let messageDelegate = HostMessageDelegate(messageBuffer: messageBuffer)
            roomManager.subscribe(messageDelegate: messageDelegate)
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
    }
}
