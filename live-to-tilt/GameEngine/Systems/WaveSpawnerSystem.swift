import CoreGraphics

final class WaveSpawnerSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let waveSpawnerComponents = nexus.getComponents(of: WaveSpawnerComponent.self)
        waveSpawnerComponents.forEach { waveSpawnerComponent in
            let waveSpawner = waveSpawnerComponent.waveSpawner
            waveSpawner.update(deltaTime: deltaTime, nexus: nexus)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}
}
