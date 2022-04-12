import CoreGraphics

/**
 Manages the statistics of the current game.
 */
class GameStats {
    private let gameMode: GameMode
    private(set) var score: Int = .zero {
        didSet {
            onStatUpdated()
        }
    }
    private(set) var powerupsDespawned: Int = .zero
    private(set) var powerupsUsed: Int = .zero
    private(set) var nukePowerupsUsed: Int = .zero {
        didSet {
            onStatUpdated()
        }
    }
    private(set) var lightsaberPowerupsUsed: Int = .zero
    private(set) var enemiesKilled: Int = .zero {
        didSet {
            // onStatUpdated() TODO: Make more extensible somehow
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

    func onStatUpdated() {
        EventManager.shared.postEvent(GameStatsUpdatedEvent(gameStats: self))
    }

    private func observePublishers() {
        EventManager.shared.registerClosureForEvent(of: GameEndedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: PowerupDespawnedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: PowerupUsedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: ScoreChangedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: EnemyKilledEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: PlayerMovedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: WaveStartedEvent.self, closure: onStatEventRef)
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
            // NOTE: Probably need to refactor this
            if powerupUsedEvent.powerup is NukePowerup {
                self.nukePowerupsUsed += 1
            } else if powerupUsedEvent.powerup is LightsaberPowerup {
                self.lightsaberPowerupsUsed += 1
            }
            self.powerupsUsed += 1

        case let scoreChangedEvent as ScoreChangedEvent:
            self.score += scoreChangedEvent.deltaScore

        case _ as EnemyKilledEvent:
            self.enemiesKilled += 1

        case let playerMovedEvent as PlayerMovedEvent:
            self.distanceTravelled += playerMovedEvent.deltaDistance

        case _ as WaveStartedEvent:
            self.wave += 1

        default:
            return
        }
    }

    func getBackdropValue() -> String {
        switch gameMode {
        case .survival:
            return score.withCommas()
        case .gauntlet:
            return playTime.toTimeString()
        }
    }

    func getGameOverStats() -> [GameOverStat] {
        switch gameMode {
        case .survival:
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
