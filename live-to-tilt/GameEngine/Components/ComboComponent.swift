import CoreGraphics

class ComboComponent: Component {
    let entity: Entity
    var base: Int
    var multiplier: Int
    var elapsedTimeSinceComboMaintainingEvent: CGFloat

    init(entity: Entity) {
        self.entity = entity
        self.base = .zero
        self.multiplier = .zero
        self.elapsedTimeSinceComboMaintainingEvent = .zero
    }
}
