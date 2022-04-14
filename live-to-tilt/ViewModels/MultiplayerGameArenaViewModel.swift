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
            self.gameRenderer = MultiplayerHostGameRenderer(gameManager: gameManager,
                                                            gameEngine: gameEngine,
                                                            gameControl: gameControl)
        } else {
            self.gameRenderer = MultiplayerGuestGameRenderer(gameManager: gameManager, gameControl: gameControl)
        }
    }

    private func attachPublishers() {

    }
}
