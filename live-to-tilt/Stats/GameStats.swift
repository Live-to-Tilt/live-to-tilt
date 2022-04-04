import Foundation

class GameStats {
    let defaults: UserDefaults
    private var observerClosures: [StatId: [(StatId) -> Void]]

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
    var totalDistanceTravelled: Float {
        defaults.float(forKey: .totalDistanceTravelled) + self.distanceTravelled
    }

    var score: Int = .zero
    var powerupsUsed: Int = .zero
    var nukePowerupsUsed: Int = .zero {
        didSet {
            onUpdateStat(statId: .nukePowerUpsUsed)
        }
    }
    var enemiesKilled: Int = .zero
    var lightsaberPowerupsUsed: Int = .zero
    var distanceTravelled: Float = .zero

    init() {
        defaults = UserDefaults.standard
        self.observerClosures = [:]
        registerAllTimeStats()
        observePublishers()
    }

    deinit {
        updateAllTimeStats()
    }

    func registerClosure(for statId: StatId, closure: @escaping (StatId) -> Void) {
        observerClosures[statId, default: []].append(closure)
    }

    func onUpdateStat(statId: StatId) {
        guard let closures = observerClosures[statId] else {
            return
        }
        for closure in closures {
            closure(statId)
        }
    }

    private func registerAllTimeStats() {
        defaults.register(defaults: [.totalScore: 0,
                                     .totalPowerupsUsed: 0,
                                     .totalNukePowerupsUsed: 0,
                                     .totalLightsaberPowerupsUsed: 0,
                                     .totalEnemiesKilled: 0,
                                     .totalGamesPlayed: 0,
                                     .totalDistanceTravelled: 0])
    }

    private func updateAllTimeStats() {
        defaults.setValue(totalScore, forKey: .totalScore)
        defaults.setValue(totalPowerupsUsed, forKey: .totalPowerupsUsed)
        defaults.setValue(totalNukePowerupsUsed, forKey: .totalNukePowerupsUsed)
        defaults.setValue(totalLightsaberPowerupsUsed, forKey: .totalLightsaberPowerupsUsed)
        defaults.setValue(totalEnemiesKilled, forKey: .totalEnemiesKilled)
        defaults.setValue(totalGamesPlayed, forKey: .totalGamesPlayed)
        defaults.setValue(totalDistanceTravelled, forKey: .totalDistanceTravelled)
    }

    private func observePublishers() {
        EventManager.shared.registerClosure(event: .gameEnded, closure: onStatEventRef)
        EventManager.shared.registerClosure(event: .nukePowerupUsed, closure: onStatEventRef)
        EventManager.shared.registerClosure(event: .enemyKilled, closure: onStatEventRef)
        EventManager.shared.registerClosure(event: .playerMoved, closure: onStatEventRef)
        EventManager.shared.registerClosure(event: .lightsaberPowerupUsed, closure: onStatEventRef)
        EventManager.shared.registerClosure(event: .scoreChanged, closure: onStatEventRef)
    }

    private lazy var onStatEventRef = { [weak self] (_ event: Event, _ eventInfo: [EventInfo: Float]?) -> Void in
        self?.onStatEvent(event, eventInfo)
    }

    private func onStatEvent(_ event: Event, _ eventInfo: [EventInfo: Float]?) {
        switch event {
        case .gameEnded:
            self.defaults.setValue(self.totalGamesPlayed + 1, forKey: .totalGamesPlayed)
        case .nukePowerupUsed:
            self.nukePowerupsUsed += 1
            self.powerupsUsed += 1
        case .lightsaberPowerupUsed:
            self.lightsaberPowerupsUsed += 1
            self.powerupsUsed += 1
        case .enemyKilled:
            self.enemiesKilled += 1
        case .playerMoved:
            let distance = eventInfo?[.distance] ?? .zero
            self.distanceTravelled += distance
        case .scoreChanged:
            let score = eventInfo?[.score] ?? .zero
            self.score = Int(score)
        default:
            return
        }
    }
}
