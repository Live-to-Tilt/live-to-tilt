import Combine
import Foundation

class MultiplayerGameArenaViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent]
    @Published var gameStateComponent: GameStateComponent?

    var gameManager: GameManager
    var gameControl: GameControl
    var gameRenderer: GameRenderer
    var gameEngine: GameEngine?

    var cancellables = Set<AnyCancellable>()

    init(gameManager: GameManager) {
        self.renderableComponents = []
        self.gameManager = gameManager
        self.gameControl = GameControlManager.shared.gameControl

        if gameManager.isHost {
            let gameEngine = GameEngine(gameMode: .survival)
            self.gameEngine = gameEngine
            self.gameRenderer = MultiplayerHostGameRenderer(gameEngine: gameEngine,
                                                            gameControl: gameControl)
        } else {
            self.gameRenderer = MultiplayerGuestGameRenderer(gameManager: gameManager,
                                                             gameControl: gameControl)
        }

        attachPublishers()
        gameRenderer.start()
    }

    private func attachPublishers() {
        if gameManager.isHost {
            let messageHandlerDelegate = GuestMessageHandlerDelegate()
            gameManager.subscribe(messageHandler: messageHandlerDelegate)

            gameEngine?.renderablePublisher.sink { [weak self] renderableComponents in
                self?.renderableComponents = renderableComponents

                let message = HostMessage(renderableComponents: renderableComponents)
                self?.gameManager.send(message: message)
            }.store(in: &cancellables)
        } else {
            let messageHandlerDelegate = HostMessageHandlerDelegate()
            gameManager.subscribe(messageHandler: messageHandlerDelegate)

            messageHandlerDelegate.renderablePublisher.sink { [weak self] renderableComponents in
                self?.renderableComponents = renderableComponents
            }.store(in: &cancellables)
        }
    }
}
