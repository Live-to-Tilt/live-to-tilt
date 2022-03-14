import Combine

class TestGameViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent] = []

    var gameEngine: GameEngine
    var gameControl: GameControl
    var gameRenderer: GameRenderer

    var cancellables = Set<AnyCancellable>()

    init() {
        gameEngine = GameEngine()
        gameControl = GameControlManager.shared.gameControl
        gameRenderer = GameRenderer(gameEngine: gameEngine, gameControl: gameControl)
        gameRenderer.start()

        gameEngine.renderablePublisher.sink { renderableComponents in
            self.renderableComponents = renderableComponents
        }.store(in: &cancellables)
    }

    deinit {
        gameRenderer.stop()
    }
}
