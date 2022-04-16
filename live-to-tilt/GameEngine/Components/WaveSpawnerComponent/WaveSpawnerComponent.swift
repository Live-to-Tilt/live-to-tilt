import CoreGraphics

class WaveSpawnerComponent: Component {
    let entity: Entity
    let waveSpawner: WaveSpawner

    init(entity: Entity, waveSpawner: WaveSpawner) {
        self.entity = entity
        self.waveSpawner = waveSpawner
    }
}
