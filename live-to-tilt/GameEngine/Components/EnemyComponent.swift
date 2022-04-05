import CoreGraphics

class EnemyComponent: Component {
    let entity: Entity
    var elapsedTimeSinceSpawn: CGFloat

    init(entity: Entity) {
        self.entity = entity
        self.elapsedTimeSinceSpawn = .zero
    }
}
