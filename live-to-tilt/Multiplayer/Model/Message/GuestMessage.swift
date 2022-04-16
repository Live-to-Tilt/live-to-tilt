import CoreGraphics

class GuestMessage: Message {
    private static var sequenceCount: Int = .zero
    let inputForce: CGVector?
    let pauseSignal: Bool
    let unpauseSignal: Bool

    init(inputForce: CGVector? = nil,
         pauseSignal: Bool = false,
         unpauseSignal: Bool = false) {
        self.inputForce = inputForce
        self.pauseSignal = pauseSignal
        self.unpauseSignal = unpauseSignal
        super.init(sequenceId: Self.sequenceCount)
        Self.sequenceCount += 1
    }

    private enum CodingKeys: String, CodingKey {
        case inputForce
        case pauseSignal
        case unpauseSignal
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.inputForce = try container.decodeIfPresent(CGVector.self,
                                                        forKey: .inputForce)
        self.pauseSignal = try container.decode(Bool.self, forKey: .pauseSignal)
        self.unpauseSignal = try container.decode(Bool.self, forKey: .unpauseSignal)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(inputForce, forKey: .inputForce)
        try container.encode(pauseSignal, forKey: .pauseSignal)
        try container.encode(unpauseSignal, forKey: .unpauseSignal)
    }
}
