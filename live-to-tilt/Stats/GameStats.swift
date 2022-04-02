import Foundation

class GameStats {
    let defaults: UserDefaults

    var totalScore: Int {
        defaults.integer(forKey: .totalScore) + self.score
    }
    var totalPowerupsUsed: Int {
        defaults.integer(forKey: .totalPowerupsUsed) + self.powerupsUsed
    }
    var totalNukePowerupsUsed: Int {
        defaults.integer(forKey: .totalNukePowerupsUsed) + self.nukePowerupsUsed
    }
    var totalLightsaberPowerupsUsed: Int {
        defaults.integer(forKey: .totalLightsaberPowerupsUsed) + self.lightsaberPowerupsUsed
    }
    var totalEnemiesKilled: Int {
        defaults.integer(forKey: .totalEnemiesKilled) + self.enemiesKilled
    }
    var totalGamesPlayed: Int {
        defaults.integer(forKey: .totalGamesPlayed)
    }
    var totalDistanceTravelled: Int {
        defaults.integer(forKey: .totalDistanceTravelled) + self.distanceTravelled
    }

    var score: Int = .zero // TODO: to update when scoring system is added
    var powerupsUsed: Int = .zero
    var nukePowerupsUsed: Int = .zero
    var lightsaberPowerupsUsed: Int = .zero
    var enemiesKilled: Int = .zero
    var distanceTravelled: Int = .zero

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
                                     .totalPowerupsUsed: 0,
                                     .totalNukePowerupsUsed: 0,
                                     .totalLightsaberPowerupsUsed: 0,
                                     .totalEnemiesKilled: 0,
                                     .totalGamesPlayed: 0,
                                     .totalDistanceTravelled: 0])
    }

    func updateAllTimeStats() {
        defaults.setValue(totalScore, forKey: .totalScore)
        defaults.setValue(totalPowerupsUsed, forKey: .totalPowerupsUsed)
        defaults.setValue(totalNukePowerupsUsed, forKey: .totalNukePowerupsUsed)
        defaults.setValue(totalLightsaberPowerupsUsed, forKey: .totalLightsaberPowerupsUsed)
        defaults.setValue(totalEnemiesKilled, forKey: .totalEnemiesKilled)
        defaults.setValue(totalGamesPlayed, forKey: .totalGamesPlayed)
        defaults.setValue(totalDistanceTravelled, forKey: .totalDistanceTravelled)
    }

    func observePublishers() {
        for event in Event.allCases {
            EventManager.shared.registerClosure(event: event, closure: onStatEventRef)
        }
    }

    lazy var onStatEventRef = { [weak self] (_ event: Event, eventInfo: [EventInfo: Int]?) -> Void in
        let data = eventInfo
        self?.onStatEvent(event, eventInfo: eventInfo)
    }

    private func onStatEvent(_ event: Event, eventInfo: [EventInfo: Int]?) {
        switch event {
        case .gameEnded:
            self.defaults.setValue(self.totalGamesPlayed + 1, forKey: .totalGamesPlayed)
        case .nukePowerUpUsed:
            self.nukePowerupsUsed += 1
            self.powerupsUsed += 1
        case .lightsaberPowerUpUsed:
            self.lightsaberPowerupsUsed += 1
            self.powerupsUsed += 1
        case .enemyKilled:
            self.enemiesKilled += 1
        case .playerMoved:
            let distance = eventInfo?[.distance] ?? .zero
            self.distanceTravelled += distance
        default:
            return
        }
    }
}
