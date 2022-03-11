import Combine

class KeyboardViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent] = []

    var gameEngine: GameEngine
    var gameControl: KeyboardControl
    var gameRenderer: GameRenderer

    var cancellables = Set<AnyCancellable>()

    init() {
        gameEngine = GameEngine()
        gameControl = KeyboardControl()
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
