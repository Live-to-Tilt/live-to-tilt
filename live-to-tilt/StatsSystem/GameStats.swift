import Foundation

class GameStats {
    let defaults: UserDefaults

    var totalScore: Int {
        defaults.integer(forKey: .totalScore) + self.score
    }
    var totalNumPowerupsUsed: Int {
        defaults.integer(forKey: .totalNumPowerupsUsed) + self.numPowerupsUsed
    }
    var totalNumNukePowerupsUsed: Int {
        defaults.integer(forKey: .totalNumNukePowerupsUsed) + self.numNukePowerupsUsed
    }
    var totalNumEnemiesKilled: Int {
        defaults.integer(forKey: .totalNumEnemiesKilled) + self.numEnemiesKilled
    }
    var totalNumGames: Int {
        defaults.integer(forKey: .totalNumGames)
    }
    var totalPlayerDistance: Int {
        defaults.integer(forKey: .totalPlayerDistance) + self.playerDistance
    }

    var score: Int = .zero // TODO: to update when scoring system is added
    var numPowerupsUsed: Int = .zero
    var numNukePowerupsUsed: Int = .zero
    var numEnemiesKilled: Int = .zero
    var playerDistance: Int = .zero

    init() {
        defaults = UserDefaults.standard
        registerAllTimeStats()
        observePublishers()
    }

    deinit {
        updateAllTimeStats()
    }

    func registerAllTimeStats() {
        defaults.register(defaults: [.totalScore: 0,
                                     .totalNumPowerupsUsed: 0,
                                     .totalNumNukePowerupsUsed: 0,
                                     .totalNumEnemiesKilled: 0,
                                     .totalNumGames: 0,
                                     .totalPlayerDistance: 0])
    }

    func updateAllTimeStats() {
        defaults.setValue(totalScore, forKey: .totalScore)
        defaults.setValue(totalNumPowerupsUsed, forKey: .totalNumPowerupsUsed)
        defaults.setValue(totalNumNukePowerupsUsed, forKey: .totalNumNukePowerupsUsed)
        defaults.setValue(totalNumEnemiesKilled, forKey: .totalNumEnemiesKilled)
        defaults.setValue(totalNumGames, forKey: .totalNumGames)
        defaults.setValue(totalPlayerDistance, forKey: .totalPlayerDistance)
    }

    func observePublishers() {
        for event in Event.allCases {
            EventManager.registerCallback(event: event,
                                          observer: self,
                                          selector: #selector(onStatEvent))
        }
    }

    @objc
    private func onStatEvent(_ notification: Notification) {
        switch notification.name {
        case Event.gameEnded.toNotificationName():
            defaults.setValue(self.totalNumGames + 1, forKey: .totalNumGames)
        case Event.nukePowerUpUsed.toNotificationName():
            self.numNukePowerupsUsed += 1
            self.numPowerupsUsed += 1
        case Event.enemyKilled.toNotificationName():
            self.numEnemiesKilled += 1
        case Event.playerMoved.toNotificationName():
            guard let data = notification.userInfo as? [EventInfo: Int],
                  let distance = data[.distance] else {
                      return
                  }
            self.playerDistance += distance
        default:
            return
        }
    }
}
