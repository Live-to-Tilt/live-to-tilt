import Foundation

/**
 Manages the All-Time statistics of the game, i.e. the cumulative stats across all games.
 */
class AllTimeStats {
    static let shared = AllTimeStats()

    private let defaults: UserDefaults

    // Cumulative stats
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

    // Highscores
    var survivalHighScore: Int {
        defaults.integer(forKey: .survivalHighScore)
    }
    var gauntletHighScore: Float {
        defaults.float(forKey: .gauntletHighScore)
    }

    private init() {
        defaults = UserDefaults.standard
        registerAllTimeStats()
    }

    private func registerAllTimeStats() {
        defaults.register(defaults: [.totalGamesPlayed: 0,
                                     .totalScore: 0,
                                     .totalPowerupsUsed: 0,
                                     .totalNukePowerupsUsed: 0,
                                     .totalLightsaberPowerupsUsed: 0,
                                     .totalEnemiesKilled: 0,
                                     .totalDistanceTravelled: 0,
                                     .survivalHighScore: 0,
                                     .gauntletHighScore: 0])
    }

    /// Update all-time stats once a game ends
    ///
    /// - Parameters:
    ///   - gameStats: stats from the latest game
    ///   - gameMode: game mode of the latest game
    func addStatsFromLatestGame(_ gameStats: GameStats, _ gameMode: GameMode) {
        updateCumulativeStats(gameStats)
        updateHighScores(gameStats, gameMode)
    }

    private func updateCumulativeStats(_ gameStats: GameStats) {
        defaults.setValue(totalGamesPlayed + 1,
                          forKey: .totalGamesPlayed)
        defaults.setValue(totalScore + gameStats.score,
                          forKey: .totalScore)
        defaults.setValue(totalPowerupsUsed + gameStats.powerupsUsed,
                          forKey: .totalPowerupsUsed)
        defaults.setValue(totalNukePowerupsUsed + gameStats.nukePowerupsUsed,
                          forKey: .totalNukePowerupsUsed)
        defaults.setValue(totalLightsaberPowerupsUsed + gameStats.lightsaberPowerupsUsed,
                          forKey: .totalLightsaberPowerupsUsed)
        defaults.setValue(totalEnemiesKilled + gameStats.enemiesKilled,
                          forKey: .totalEnemiesKilled)
        defaults.setValue(totalDistanceTravelled + gameStats.distanceTravelled,
                          forKey: .totalDistanceTravelled)
    }

    private func updateHighScores(_ gameStats: GameStats, _ gameMode: GameMode) {
        switch gameMode {
        case .survival:
            if gameStats.score > survivalHighScore {
                defaults.setValue(gameStats.score, forKey: .survivalHighScore)
            }
        case .gauntlet:
            if gameStats.playTime > gauntletHighScore {
                defaults.setValue(gameStats.playTime, forKey: .gauntletHighScore)
            }
        }
    }

    func getHighScore(for gameMode: GameMode) -> String {
        switch gameMode {
        case .survival:
            return String(survivalHighScore)
        case .gauntlet:
            return gauntletHighScore.toTimeString()
        }
    }
}
