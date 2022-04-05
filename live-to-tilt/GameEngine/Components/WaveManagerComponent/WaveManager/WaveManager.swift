import CoreGraphics

protocol WaveManager {
    func update(deltaTime: CGFloat)

    func canStartNextWave(nexus: Nexus) -> Bool

    func startNextWave(nexus: Nexus)
}

extension WaveManager {
    func update(deltaTime: CGFloat, nexus: Nexus) {
        update(deltaTime: deltaTime)

        if canStartNextWave(nexus: nexus) {
            startNextWave(nexus: nexus)
            EventManager.shared.postEvent(.waveStarted)
        }
    }
}
