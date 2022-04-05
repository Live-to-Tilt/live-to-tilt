import CoreGraphics

final class PowerupManagerSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let powerupManagerComponents = nexus.getComponents(of: PowerupManagerComponent.self)
        powerupManagerComponents.forEach { powerupManagerComponent in
            let powerupManager = powerupManagerComponent.powerupManager
            powerupManager.update(nexus: nexus, deltaTime: deltaTime)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}
}
