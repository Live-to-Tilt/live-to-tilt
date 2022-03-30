import CoreGraphics

class PowerupComponent: Component {
    let entity: Entity
    let effect: PowerupEffect
    var elapsedTimeSinceSpawn: Double = 0
    var isActive = false

    init(entity: Entity, effect: PowerupEffect) {
        self.entity = entity
        self.effect = effect
    }
}
