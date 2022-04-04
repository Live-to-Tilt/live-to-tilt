import Foundation

/**
 Manages the All-Time statistics of the game, i.e. the cumulative stats across all games.
 */
class AllTimeStats {
    let defaults: UserDefaults

    var totalGamesPlayed: Int {
        defaults.integer(forKey: .totalGamesPlayed)
    }
    var totalScore: Int {
        defaults.integer(forKey: .totalScore)
    }
    var totalPowerupsUsed: Int {
        defaults.integer(forKey: .totalPowerupsUsed)
    }
    var totalNukePowerupsUsed: Int {
        defaults.integer(forKey: .totalNukePowerupsUsed)
    }
    var totalLightsaberPowerupsUsed: Int {
        defaults.integer(forKey: .totalLightsaberPowerupsUsed)
    }
    var totalEnemiesKilled: Int {
        defaults.integer(forKey: .totalEnemiesKilled)
    }
    var totalDistanceTravelled: Float {
        defaults.float(forKey: .totalDistanceTravelled)
    }

    init() {
        defaults = UserDefaults.standard
        registerAllTimeStats()
        observePublishers()
    }

    private func registerAllTimeStats() {
        defaults.register(defaults: [.totalGamesPlayed: 0,
                                     .totalScore: 0,
                                     .totalPowerupsUsed: 0,
                                     .totalNukePowerupsUsed: 0,
                                     .totalLightsaberPowerupsUsed: 0,
                                     .totalEnemiesKilled: 0,
                                     .totalDistanceTravelled: 0])
    }

    private func observePublishers() {
        EventManager.shared.registerClosure(event: .gameEnded, closure: onStatEventRef)
    }

    private lazy var onStatEventRef = { [weak self] (_: Event, eventInfo: EventInfo?) -> Void in
        self?.onStatEvent(eventInfo)
    }

    // Update all-time stats once a game ends
    private func onStatEvent(_ eventInfo: EventInfo?) {
        defaults.setValue(totalGamesPlayed + 1,
                          forKey: .totalGamesPlayed)

        let score = eventInfo?[.score] ?? .zero
        defaults.setValue(totalScore + Int(score),
                          forKey: .totalScore)

        let nukePowerupsUsed = eventInfo?[.nukePowerupsUsed] ?? .zero
        defaults.setValue(totalNukePowerupsUsed + Int(nukePowerupsUsed),
                          forKey: .totalNukePowerupsUsed)

        let lightsaberPowerupsUsed = eventInfo?[.lightsaberPowerupsUsed] ?? .zero
        defaults.setValue(totalLightsaberPowerupsUsed + Int(lightsaberPowerupsUsed),
                          forKey: .totalLightsaberPowerupsUsed)

        let enemiesKilled = eventInfo?[.enemiesKilled] ?? .zero
        defaults.setValue(totalEnemiesKilled + Int(enemiesKilled),
                          forKey: .totalEnemiesKilled)

        let distanceTravelled = eventInfo?[.distanceTravelled] ?? .zero
        defaults.setValue(totalDistanceTravelled + distanceTravelled,
                          forKey: .totalDistanceTravelled)
    }
}
