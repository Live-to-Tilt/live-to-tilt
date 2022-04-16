import CoreGraphics

class PowerupSpawnerComponent: Component {
    let entity: Entity
    let powerupSpawner: PowerupSpawner

    init(entity: Entity, powerupSpawner: PowerupSpawner) {
        self.entity = entity
        self.powerupSpawner = powerupSpawner
    }
}
