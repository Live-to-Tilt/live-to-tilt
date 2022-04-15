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

        attachSubscribers()
        attachPublishers()
        gameRenderer.start()
    }

    private func attachSubscribers() {
        if roomManager.isHost {
            let messageDelegate = GuestMessageDelegate()
            roomManager.subscribe(messageDelegate: messageDelegate)
        } else {
            guard let guestGameRenderer = gameRenderer as? MultiplayerGuestGameRenderer else {
                return
            }

            let messageBuffer = guestGameRenderer.messageBuffer
            let messageDelegate = HostMessageDelegate(messageBuffer: messageBuffer)
            roomManager.subscribe(messageDelegate: messageDelegate)
        }
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
