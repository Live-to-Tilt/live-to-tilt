import CoreGraphics

struct GameStateInfo: Codable {
    let state: GameStateComponent.GameState

    init(gameStateComponent: GameStateComponent) {
        self.state = gameStateComponent.state
    }

    func toGameStateComponent(entity: Entity) -> GameStateComponent {
        let gameStateComponent = GameStateComponent(entity: entity,
                                                    state: state)
        return gameStateComponent
    }
}
