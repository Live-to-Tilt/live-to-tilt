import CoreGraphics

final class WaveManagerSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let waveManagerComponents = nexus.getComponents(of: WaveManagerComponent.self)
        waveManagerComponents.forEach { waveManagerComponent in
            let waveManager = waveManagerComponent.waveManager
            waveManager.update(deltaTime: deltaTime, nexus: nexus)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}
}
