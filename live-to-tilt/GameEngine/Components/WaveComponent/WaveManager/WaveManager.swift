import CoreGraphics

protocol WaveManager {
    func update(deltaTime: CGFloat)

    func canStartNextWave(nexus: Nexus) -> Bool

    func startNextWave(nexus: Nexus)
}
