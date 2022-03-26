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
            EventManager.registerClosure(event: event, closure: onStatEvent(_:eventInfo:))
        }
    }

    private func onStatEvent(_ event: Event, eventInfo: [EventInfo: Int]?) {
        switch event {
        case Event.gameEnded:
            defaults.setValue(self.totalNumGames + 1, forKey: .totalNumGames)
            print("game ended")
        case Event.nukePowerUpUsed:
            self.numNukePowerupsUsed += 1
            self.numPowerupsUsed += 1
            print("Nuke used")
        case Event.enemyKilled:
            self.numEnemiesKilled += 1
            print("enemy killed")
        case Event.playerMoved:
            guard let data = eventInfo,
                  let distance = data[.distance] else {
                      return
                  }
            self.playerDistance += distance
        default:
            return
        }
    }
}
