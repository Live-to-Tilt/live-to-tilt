import CoreGraphics

class GameStateComponent: Component {
    let entity: Entity
    var state: GameState {
        didSet {
            if state == .gameOver {
                EventManager.shared.postEvent(GameEndedEvent())
            }
        }
    }

    enum GameState: String, Codable {
        case play
        case pause
        case gameOver
    }

    init(entity: Entity, state: GameState = .play) {
        self.entity = entity
        self.state = state
    }
}
