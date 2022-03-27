import CoreGraphics

final class WaveSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let waveComponents = nexus.getComponents(of: WaveComponent.self)
        waveComponents.forEach { waveComponent in
            let waveManager = waveComponent.waveManager
            waveManager.update(deltaTime: deltaTime)

            if waveManager.canStartNextWave(nexus: nexus) {
                waveManager.startNextWave(nexus: nexus)
            }
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}
}
