import CoreGraphics

class LifespanComponent: Component {
    let entity: Entity
    let maxLifespan: CGFloat?
    var elapsedTimeSinceSpawn: CGFloat

    init(entity: Entity, lifespan: CGFloat? = nil) {
        self.entity = entity
        self.maxLifespan = lifespan
        self.elapsedTimeSinceSpawn = .zero
    }
}
