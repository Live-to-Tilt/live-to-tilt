import CoreGraphics

class PowerupComponent: Component {
    let entity: Entity
    let powerup: Powerup
    var elapsedTimeSinceSpawn: CGFloat

    init(entity: Entity, powerup: Powerup) {
        self.entity = entity
        self.powerup = powerup
        self.elapsedTimeSinceSpawn = .zero
    }
}
