import CoreGraphics

class ComboComponent: Component {
    let entity: Entity
    var base: Int
    var multiplier: Int
    var elapsedTimeSincePreviousAccumulate: CGFloat
    var comboScore: Int {
        base * multiplier
    }

    init(entity: Entity,
         base: Int = .zero,
         multiplier: Int = .zero,
         elapsedTimeSincePreviousAccumulate: CGFloat = .zero) {
        self.entity = entity
        self.base = base
        self.multiplier = multiplier
        self.elapsedTimeSincePreviousAccumulate = elapsedTimeSincePreviousAccumulate
    }
}
