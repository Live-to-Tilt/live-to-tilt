import CoreGraphics

class ComboComponent: Component {
    let entity: Entity
    var base: Int
    var multiplier: Int
    var elapsedTimeSincePreviousAccumulate: CGFloat
    var comboScore: Int {
        base * multiplier
    }

    init(entity: Entity) {
        self.entity = entity
        self.base = .zero
        self.multiplier = .zero
        self.elapsedTimeSincePreviousAccumulate = .zero
    }
}
