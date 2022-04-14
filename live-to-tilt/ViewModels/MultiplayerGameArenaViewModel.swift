import Combine
import Foundation

class MultiplayerGameArenaViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent]
    @Published var gameStateComponent: GameStateComponent?

    var gameEngine: GameEngine
    var gameControl: GameControl
    var gameRenderer: GameRenderer

    init() {
        renderableComponents = []
        gameEngine = GameEngine(gameMode: .survival)
        gameControl = GameControlManager.shared.gameControl
        gameRenderer = GameRenderer(gameEngine: gameEngine, gameControl: gameControl)
    }
}
