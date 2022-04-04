import CoreGraphics

class GameStateComponent: Component {
    let entity: Entity
    var state: GameState {
        didSet {
            if state == .gameOver {
                EventManager.shared.postEvent(.gameEnded)
            }
        }
    }

    enum GameState {
        case play
        case pause
        case gameOver
    }

    init(entity: Entity) {
        self.entity = entity
        self.state = .play
    }
}
