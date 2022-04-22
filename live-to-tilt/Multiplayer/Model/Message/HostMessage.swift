class HostMessage: Message {
    private static var sequenceCount: Int = .zero
    private let gameStateInfo: GameStateInfo?
    private let renderablesInfo: [RenderableInfo]
    private let comboInfo: ComboInfo?
    private let gameStatsInfo: GameStatsInfo?

    var gameStateComponent: GameStateComponent? {
        guard let gameStateInfo = gameStateInfo else {
            return nil
        }

        return gameStateInfo.toGameStateComponent(entity: Entity())
    }

    var renderableComponents: [RenderableComponent] {
        renderablesInfo.map { $0.toRenderableComponent(entity: Entity()) }
    }

    var comboComponent: ComboComponent? {
        guard let comboInfo = comboInfo else {
            return nil
        }

        return comboInfo.toComboComponent(entity: Entity())
    }

    var gameStats: GameStats? {
        guard let gameStatsInfo = gameStatsInfo else {
            return nil
        }
        return gameStatsInfo.toGameStats()
    }

    init(gameStateComponent: GameStateComponent?,
         renderableComponents: [RenderableComponent],
         comboComponent: ComboComponent?,
         gameStats: GameStats?) {
        self.gameStateInfo = GameStateInfo(gameStateComponent: gameStateComponent)
        self.renderablesInfo = renderableComponents.map { RenderableInfo($0) }
        self.comboInfo = ComboInfo(comboComponent: comboComponent)
        self.gameStatsInfo = GameStatsInfo(gameStats: gameStats)
        super.init(sequenceId: Self.sequenceCount)
        Self.sequenceCount += 1
    }

    private enum CodingKeys: String, CodingKey {
        case gameStateInfo
        case renderablesInfo
        case comboInfo
        case gameStatsInfo
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gameStateInfo = try container.decodeIfPresent(GameStateInfo.self,
                                                           forKey: .gameStateInfo)
        self.renderablesInfo = try container.decode([RenderableInfo].self,
                                                    forKey: .renderablesInfo)
        self.comboInfo = try container.decodeIfPresent(ComboInfo.self,
                                                       forKey: .comboInfo)
        self.gameStatsInfo = try container.decodeIfPresent(GameStatsInfo.self,
                                                           forKey: .gameStatsInfo)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(gameStateInfo, forKey: .gameStateInfo)
        try container.encode(renderablesInfo, forKey: .renderablesInfo)
        try container.encodeIfPresent(comboInfo, forKey: .comboInfo)
        try container.encodeIfPresent(gameStatsInfo, forKey: .gameStatsInfo)
    }
}
