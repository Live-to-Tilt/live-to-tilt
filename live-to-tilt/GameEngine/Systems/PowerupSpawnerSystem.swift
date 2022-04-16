import CoreGraphics

final class PowerupSpawnerSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let powerupSpawnerComponents = nexus.getComponents(of: PowerupSpawnerComponent.self)
        powerupSpawnerComponents.forEach { powerupSpawnerComponent in
            let powerupSpawner = powerupSpawnerComponent.powerupSpawner
            powerupSpawner.update(deltaTime: deltaTime)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}
}
