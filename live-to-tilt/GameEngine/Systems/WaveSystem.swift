import CoreGraphics

final class WaveSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let waveComponents = nexus.getComponents(of: WaveComponent.self)
        waveComponents.forEach { waveComponent in
            var waveManager = waveComponent.waveManager
            waveManager.update(nexus: nexus, deltaTime: deltaTime)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}
}
