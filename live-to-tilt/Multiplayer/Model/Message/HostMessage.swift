class HostMessage: Message {
    private static var sequenceCount: Int = .zero
    let renderableComponents: [RenderableComponent]

    init(renderableComponents: [RenderableComponent]) {
        self.renderableComponents = renderableComponents
        super.init(sequenceId: Self.sequenceCount)
        Self.sequenceCount += 1
    }

    private enum CodingKeys: String, CodingKey {
        case renderableComponents
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.renderableComponents = try container.decode([RenderableComponent].self,
                                                         forKey: .renderableComponents)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(renderableComponents, forKey: .renderableComponents)
    }
}
