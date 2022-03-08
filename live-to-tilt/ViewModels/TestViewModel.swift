import Combine

class TestViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent] = []

    var gameEngine: GameEngine
    var gameLoop: GameLoop

    var cancellables = Set<AnyCancellable>()

    init() {
        gameEngine = GameEngine()
        gameLoop = GameLoop(gameEngine: gameEngine)
        gameLoop.start()

        gameEngine.renderablePublisher.sink { renderableComponents in
            self.renderableComponents = renderableComponents
        }.store(in: &cancellables)
    }

    deinit {
        gameLoop.stop()
    }
}
