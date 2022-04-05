import CoreGraphics

class LifespanComponent: Component {
    let entity: Entity
    let lifespan: CGFloat
    var elapsedTimeSinceSpawn: CGFloat

    init(entity: Entity, lifespan: CGFloat) {
        self.entity = entity
        self.lifespan = lifespan
        self.elapsedTimeSinceSpawn = .zero
    }
}
