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
    var comboBase: Int
    var comboMultiplier: Int
    var elapsedTimeSincePreviousComboAccumulate: CGFloat

    enum GameState {
        case play
        case pause
        case gameOver
    }

    init(entity: Entity) {
        self.entity = entity
        self.state = .play
        self.comboBase = .zero
        self.comboMultiplier = .zero
        self.elapsedTimeSincePreviousComboAccumulate = .zero
    }
}
