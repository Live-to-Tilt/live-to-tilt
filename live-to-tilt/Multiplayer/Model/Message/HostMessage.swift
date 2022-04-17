class HostMessage: Message {
    private static var sequenceCount: Int = .zero
    private let renderablesInfo: [RenderableInfo]
    var renderableComponents: [RenderableComponent] {
        renderablesInfo.map { $0.toRenderableComponent(entity: Entity()) }
    }

    init(renderableComponents: [RenderableComponent]) {
        self.renderablesInfo = renderableComponents.map { RenderableInfo($0) }
        super.init(sequenceId: Self.sequenceCount)
        Self.sequenceCount += 1
    }

    private enum CodingKeys: String, CodingKey {
        case renderablesInfo
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.renderablesInfo = try container.decode([RenderableInfo].self,
                                                    forKey: .renderablesInfo)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(renderablesInfo, forKey: .renderablesInfo)
    }
}
