import Foundation

class GameStats {
    var totalScore: Int {
        defaults.integer(forKey: .totalScore) + self.currScore
    }
    var totalNumPowerupsUsed: Int {
        defaults.integer(forKey: .totalNumPowerupsUsed) + self.currNumPowerupsUsed
    }
    var totalEnemiesKilled: Int {
        defaults.integer(forKey: .totalEnemiesKilled) + self.totalEnemiesKilled
    }
    var totalNumGames: Int {
        defaults.integer(forKey: .totalNumGames)
    }

    var currScore: Int = 0
    var currNumPowerupsUsed: Int = 0
    var numEnemiesKilled: Int = 0

    let defaults: UserDefaults

    init() {
        defaults = UserDefaults.standard
        registerAllTimeStats()
    }

    func registerAllTimeStats() {
        guard defaults.integer(forKey: .totalNumGames) == 0 else {
            return
        }
        defaults.register(defaults: [.totalScore: 0,
                                     .totalNumPowerupsUsed: 0,
                                     .totalEnemiesKilled: 0,
                                     .totalNumGames: 0])
    }

    func updateAllTimeStats() {
        defaults.setValue(totalScore, forKey: .totalScore)
        defaults.setValue(totalNumPowerupsUsed, forKey: .totalNumPowerupsUsed)
        defaults.setValue(totalEnemiesKilled, forKey: .totalEnemiesKilled)
        defaults.setValue(totalNumGames, forKey: .totalNumGames)
    }
}
