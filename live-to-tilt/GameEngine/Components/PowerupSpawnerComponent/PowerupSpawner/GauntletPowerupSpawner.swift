import CoreGraphics

class GauntletPowerupSpawner: PowerupSpawner {
    private let nexus: Nexus
    private let powerupIterator: AnyIterator<Powerup>

    init(nexus: Nexus) {
        let powerups: [Powerup] = [
            TimePowerup()
        ]
        self.powerupIterator = powerups.makeRandomIterator()
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
        guard let powerup = powerupIterator.next() else {
            return
        }

        var movement: Movement = BaseMovement()
        movement = DirectionalMovementDecorator(movement: movement, direction: .left)
        nexus.createPowerup(position: position,
                            powerup: powerup,
                            collisionBitmask: Constants.gauntletOrbCollisionBitmask,
                            movement: movement,
                            despawnOutsideArena: true)
    }
}
