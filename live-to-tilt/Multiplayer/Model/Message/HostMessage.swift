class HostMessage: Message {
    private static var sequenceCount: Int = .zero
    private let gameStateInfo: GameStateInfo?
    private let renderablesInfo: [RenderableInfo]

    var gameStateComponent: GameStateComponent? {
        guard let gameStateInfo = gameStateInfo else {
            return nil
        }

        return gameStateInfo.toGameStateComponent(entity: Entity())
    }

    var renderableComponents: [RenderableComponent] {
        renderablesInfo.map { $0.toRenderableComponent(entity: Entity()) }
    }

    init(gameStateComponent: GameStateComponent?, renderableComponents: [RenderableComponent]) {
        if let gameStateComponent = gameStateComponent {
            self.gameStateInfo = GameStateInfo(gameStateComponent: gameStateComponent)
        } else {
            self.gameStateInfo = nil
        }
        self.renderablesInfo = renderableComponents.map { RenderableInfo($0) }
        super.init(sequenceId: Self.sequenceCount)
        Self.sequenceCount += 1
    }

    private enum CodingKeys: String, CodingKey {
        case gameStateInfo
        case renderablesInfo
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gameStateInfo = try container.decodeIfPresent(GameStateInfo.self,
                                                           forKey: .gameStateInfo)
        self.renderablesInfo = try container.decode([RenderableInfo].self,
                                                    forKey: .renderablesInfo)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(gameStateInfo, forKey: .gameStateInfo)
        try container.encode(renderablesInfo, forKey: .renderablesInfo)
    }
}
