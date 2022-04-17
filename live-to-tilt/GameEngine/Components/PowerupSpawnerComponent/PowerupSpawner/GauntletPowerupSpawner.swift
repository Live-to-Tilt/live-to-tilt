import CoreGraphics

class GauntletPowerupSpawner: PowerupSpawner {
    private let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
        subscribeToEvents()
    }

    func update(deltaTime: CGFloat) {

    }

    private func subscribeToEvents() {
        EventManager.shared.registerClosure(for: WaveSpawnedEvent.self, closure: onWaveSpawn)
    }

    private lazy var onWaveSpawn = { [weak self] (event: Event) -> Void in
        guard let waveSpawnedEvent = event as? WaveSpawnedEvent,
              let gapWave = waveSpawnedEvent.wave as? GapWave else {
            return
        }

        let gapCenter = gapWave.gapCenter
        let spawnPosition = CGPoint(x: gapCenter.x + Constants.enemyDiameter / 2, y: gapCenter.y)
        self?.spawnPowerup(at: spawnPosition)
    }

    private func spawnPowerup(at position: CGPoint) {
        var movement: Movement = BaseMovement()
        movement = DirectionalMovementDecorator(movement: movement, direction: .left)
        nexus.createPowerup(position: position,
                            powerup: TimePowerup(),
                            collisionBitmask: Constants.gauntletOrbCollisionBitmask,
                            movement: movement,
                            despawnOutsideArena: true)
    }
}
