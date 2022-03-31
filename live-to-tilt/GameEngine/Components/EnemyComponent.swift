import CoreGraphics

class EnemyComponent: Component {
    let entity: Entity
    var elapsedDuration: CGFloat

    init(entity: Entity) {
        self.entity = entity
        self.elapsedDuration = .zero
    }
}
