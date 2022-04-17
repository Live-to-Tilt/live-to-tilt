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
              let gapWave = waveSpawnedEvent.wave as? GapWave,
              let smallestGap = gapWave.gaps.min(by: { $0.height < $1.height }) else {
            return
        }

        let smallestGapCenter = CGPoint(x: smallestGap.midX, y: smallestGap.midY)
        let spawnPosition = CGPoint(x: smallestGapCenter.x + Constants.enemyDiameter / 2, y: smallestGapCenter.y)
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
