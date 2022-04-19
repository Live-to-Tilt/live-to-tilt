import CoreGraphics

struct GameStateInfo: Codable {
    private let state: GameStateComponent.GameState

    init?(gameStateComponent: GameStateComponent?) {
        guard let gameStateComponent = gameStateComponent else {
            return nil
        }

        self.state = gameStateComponent.state
    }

    func toGameStateComponent(entity: Entity) -> GameStateComponent {
        let gameStateComponent = GameStateComponent(entity: entity,
                                                    state: state)
        return gameStateComponent
    }
}
