import Foundation

class GameStats {
    var totalScore: Int {
        defaults.integer(forKey: .totalScore) + self.currScore
    }
    var totalNumPowerupsUsed: Int {
        defaults.integer(forKey: .powerupUseCount) + self.currNumPowerupsUsed
    }
    var totalEnemiesKilled: Int {
        defaults.integer(forKey: .enemyKillCount) + self.totalEnemiesKilled
    }
    var totalNumGames: Int {
        defaults.integer(forKey: .gameCount)
    }

    var currScore: Int = .zero
    var currNumPowerupsUsed: Int = .zero
    var currEnemiesKilled: Int = .zero

    let defaults: UserDefaults

    init() {
        defaults = UserDefaults.standard
        registerAllTimeStats()
        observePublishers()
    }

    func registerAllTimeStats() {
        defaults.register(defaults: [.totalScore: 0,
                                     .powerupUseCount: 0,
                                     .enemyKillCount: 0,
                                     .gameCount: 0])
    }

    func updateAllTimeStats() {
        defaults.setValue(totalScore, forKey: .totalScore)
        defaults.setValue(totalNumPowerupsUsed, forKey: .powerupUseCount)
        defaults.setValue(totalEnemiesKilled, forKey: .enemyKillCount)
        defaults.setValue(totalNumGames, forKey: .gameCount)
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
