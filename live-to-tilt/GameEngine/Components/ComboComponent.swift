import CoreGraphics

class ComboComponent: Component {
    let entity: Entity
    var base: Int
    var multiplier: Int
    var elapsedTimeSinceComboAccumulatingEvent: CGFloat

    init(entity: Entity) {
        self.entity = entity
        self.base = .zero
        self.multiplier = .zero
        self.elapsedTimeSinceComboAccumulatingEvent = .zero
    }
}
