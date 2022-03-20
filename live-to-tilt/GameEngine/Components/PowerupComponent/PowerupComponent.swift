import CoreGraphics

class PowerupComponent: Component {
    let entity: Entity
    let effect: PowerupEffect
    var isActive = false
    var elapsedTimeSinceSpawn: Double = 0

    init(entity: Entity, effect: PowerupEffect) {
        self.entity = entity
        self.effect = effect
    }
}
