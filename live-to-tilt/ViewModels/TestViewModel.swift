import Combine

class TestViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent] = []

    var gameEngine: GameEngine
    var gameRenderer: GameRenderer

    var cancellables = Set<AnyCancellable>()

    init() {
        gameEngine = GameEngine()
        gameRenderer = GameRenderer(gameEngine: gameEngine)
        gameRenderer.start()

        gameEngine.renderablePublisher.sink { renderableComponents in
            self.renderableComponents = renderableComponents
        }.store(in: &cancellables)
    }

    deinit {
        gameRenderer.stop()
    }
}
