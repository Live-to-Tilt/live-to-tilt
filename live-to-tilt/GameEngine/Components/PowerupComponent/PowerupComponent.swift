import CoreGraphics

class PowerupComponent: Component {
    let entity: Entity
    let powerup: Powerup

    init(entity: Entity, powerup: Powerup) {
        self.entity = entity
        self.powerup = powerup
    }
}
