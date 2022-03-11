import Combine
import CoreGraphics

class KeyboardViewModel: ObservableObject {
    @Published var renderableComponents: [RenderableComponent] = []

    var gameEngine: GameEngine
    var gameControl: GameControl
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

    // TODO: Improve this, currently a proof of concept
    func handleDirection(_ key: String) {
        switch key {
        case "w":
            gameControl.setAcceleration(CGVector(dx: 1, dy: 0))
        case "s":
            gameControl.setAcceleration(CGVector(dx: -1, dy: 0))
        case "a":
            gameControl.setAcceleration(CGVector(dx: 0, dy: 1))
        case "d":
            gameControl.setAcceleration(CGVector(dx: 0, dy: -1))
        default:
            return
        }
    }
}
