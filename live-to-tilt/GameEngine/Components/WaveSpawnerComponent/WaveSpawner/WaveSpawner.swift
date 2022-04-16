import CoreGraphics

protocol WaveSpawner {
    func update(deltaTime: CGFloat)

    func canSpawnNextWave(nexus: Nexus) -> Bool

    func spawnNextWave(nexus: Nexus)
}

extension WaveSpawner {
    func update(deltaTime: CGFloat, nexus: Nexus) {
        update(deltaTime: deltaTime)

        if canSpawnNextWave(nexus: nexus) {
            spawnNextWave(nexus: nexus)
        }
    }
}
