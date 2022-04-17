import CoreGraphics

/**
 Manages the statistics of the current game.
 */
class GameStats {
    private let gameMode: GameMode
    private(set) var score: Int = .zero
    private(set) var powerupsDespawned: Int = .zero
    private(set) var powerupsUsed: Int = .zero
    private(set) var nukePowerupsUsed: Int = .zero
    private(set) var lightsaberPowerupsUsed: Int = .zero
    private(set) var freezePowerupsUsed: Int = .zero
    private(set) var enemiesKilled: Int = .zero {
        didSet {
            EventManager.shared.postEvent(EnemiesKilledStatUpdateEvent(gameStats: self))
        }
    }
    private(set) var distanceTravelled: Float = .zero
    private(set) var playTime: Float = .zero
    private(set) var wave: Int = .zero

    init(gameMode: GameMode) {
        self.gameMode = gameMode
        observePublishers()
    }

    func incrementPlayTime(deltaTime: CGFloat) {
        playTime += Float(deltaTime)
    }

    private func observePublishers() {
        EventManager.shared.registerClosure(for: GameEndedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosure(for: PowerupDespawnedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosure(for: PowerupUsedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosure(for: ScoreChangedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosure(for: EnemyKilledEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosure(for: PlayerMovedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosure(for: WaveSpawnedEvent.self, closure: onStatEventRef)
    }

    private lazy var onStatEventRef = { [weak self] (event: Event) -> Void in
        self?.onStatEvent(event)
    }

    /// Update game stats based on the received event
    ///
    /// - Parameters:
    ///   - event: event received
    private func onStatEvent(_ event: Event) {
        switch event {
        case _ as GameEndedEvent:
            AllTimeStats.shared.addStatsFromLatestGame(self, gameMode)

        case _ as PowerupDespawnedEvent:
            self.powerupsDespawned += 1

        case let powerupUsedEvent as PowerupUsedEvent:
            onPowerupUsedEvent(powerupUsedEvent)

        case let scoreChangedEvent as ScoreChangedEvent:
            self.score += scoreChangedEvent.deltaScore

        case _ as EnemyKilledEvent:
            self.enemiesKilled += 1

        case let playerMovedEvent as PlayerMovedEvent:
            self.distanceTravelled += playerMovedEvent.deltaDistance

        case _ as WaveSpawnedEvent:
            self.wave += 1

        default:
            return
        }
    }

    private func onPowerupUsedEvent(_ powerupUsedEvent: PowerupUsedEvent) {
        if powerupUsedEvent.powerup is NukePowerup {
            self.nukePowerupsUsed += 1
        } else if powerupUsedEvent.powerup is LightsaberPowerup {
            self.lightsaberPowerupsUsed += 1
        } else if powerupUsedEvent.powerup is FreezePowerup {
            self.freezePowerupsUsed += 1
        }
        self.powerupsUsed += 1
    }

    func getBackdropValue() -> String {
        switch gameMode {
        case .survival, .coop:
            return score.withCommas()
        case .gauntlet:
            return playTime.toTimeString()
        }
    }

    func getGameOverStats() -> [GameOverStat] {
        switch gameMode {
        case .survival, .coop:
            return [
                GameOverStat(label: "Score", value: score.withCommas()),
                GameOverStat(label: "Time", value: playTime.toTimeString()),
                GameOverStat(label: "Dead Dots", value: enemiesKilled.withCommas())
            ]
        case .gauntlet:
            return [
                GameOverStat(label: "Time", value: playTime.toTimeString()),
                GameOverStat(label: "Waves", value: wave.withCommas()),
                GameOverStat(label: "Pickups", value: "\(powerupsUsed) of \(powerupsUsed + powerupsDespawned)")
            ]
        }
    }
}
