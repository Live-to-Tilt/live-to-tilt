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
    var currEnemiesKilled: Int = 0

    let defaults: UserDefaults

    init() {
        defaults = UserDefaults.standard
        registerAllTimeStats()
        observePublishers()
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

    func observePublishers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onIncrementStat),
                                               name: StatsKey.score.toNotificationName(),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onIncrementStat),
                                               name: StatsKey.numEnemiesKilled.toNotificationName(),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onIncrementStat),
                                               name: StatsKey.numPowerupsUsed.toNotificationName(),
                                               object: nil)
    }

    @objc
    func onIncrementStat(_ notification: Notification) {
        switch notification.name {
        case StatsKey.numPowerupsUsed.toNotificationName():
            self.currNumPowerupsUsed += 1
            print("powerups incremented!!")
        case StatsKey.numEnemiesKilled.toNotificationName():
            self.currEnemiesKilled += 1
        case StatsKey.score.toNotificationName():
            guard let data = notification.userInfo as? [String: Int],
                  let score = data[StatsKey.score.rawValue] else {
                      return
                  }
            self.currScore += score
        default:
            return
        }
    }
}
