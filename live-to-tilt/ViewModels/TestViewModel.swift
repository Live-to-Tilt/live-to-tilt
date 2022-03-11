import Combine

class TestViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent] = []

    var gameEngine: GameEngine
    var gameControl: AccelerometerControl
    var gameRenderer: GameRenderer

    var cancellables = Set<AnyCancellable>()

    init() {
        gameEngine = GameEngine()
        gameControl = AccelerometerControl()
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
