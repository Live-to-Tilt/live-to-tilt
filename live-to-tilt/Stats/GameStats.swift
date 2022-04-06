import CoreGraphics

/**
 Manages the statistics of the current game.
 */
class GameStats {
    private let gameMode: GameMode
    private(set) var score: Int = .zero
//    {
//        didSet {
//            onUpdateStat(.updateScore, value: score)
//        }
//    }
    private(set) var powerupsUsed: Int = .zero
    private(set) var nukePowerupsUsed: Int = .zero
//    {
//        didSet {
//            onUpdateStat(.updateNukePowerUpsUsed, value: nukePowerupsUsed)
//        }
//    }
    private(set) var lightsaberPowerupsUsed: Int = .zero
    private(set) var enemiesKilled: Int = .zero
//    {
//        didSet {
//            onUpdateStat(.updateEnemiesKilled, value: enemiesKilled)
//        }
//    }
    private(set) var distanceTravelled: Float = .zero
    private(set) var playTime: Float = .zero

    init(gameMode: GameMode) {
        self.gameMode = gameMode
        observePublishers()
    }

    func incrementPlayTime(deltaTime: CGFloat) {
        playTime += Float(deltaTime)
    }

//    func onUpdateStat(_ statUpdated: Event, value: Int) {
        // TODO: Re-enable
//        EventManager.shared.postEventOld(statUpdated, eventInfo: [.statValue: Float(value)])
//    }

    private func observePublishers() {
        EventManager.shared.registerClosureForEvent(of: GameEndedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: PowerupUsedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: ScoreChangedEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: EnemyKilledEvent.self, closure: onStatEventRef)
        EventManager.shared.registerClosureForEvent(of: PlayerMovedEvent.self, closure: onStatEventRef)

//        for event in Event.allCases {
//            EventManager.shared.registerClosure(event: event, closure: onStatEventRef)
//        }
    }

    private lazy var onStatEventRef = { [weak self] (event: Event) -> Void in
        self?.onStatEvent(event)
    }

    /// Update game stats based on the received event
    ///
    /// - Parameters:
    ///   - event: type of event received
    private func onStatEvent(_ event: Event) {
        switch event {
        case _ as GameEndedEvent:
            AllTimeStats.shared.addStatsFromLatestGame(self, gameMode)

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
        var stats: [GameOverStat] = []

        switch gameMode {
        case .survival:
            stats.append(GameOverStat(label: "Score", value: score.withCommas()))
            stats.append(GameOverStat(label: "Time", value: playTime.toTimeString()))
            stats.append(GameOverStat(label: "Dead Dots", value: enemiesKilled.withCommas()))
        case .gauntlet:
            stats.append(GameOverStat(label: "Time", value: playTime.toTimeString()))
        }

        return stats
    }
}
