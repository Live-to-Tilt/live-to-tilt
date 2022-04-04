/**
 Manages the statistics of the current game.
 */
class GameStats {
    var score: Int = .zero
    var powerupsUsed: Int = .zero
    var nukePowerupsUsed: Int = .zero
    var lightsaberPowerupsUsed: Int = .zero
    var enemiesKilled: Int = .zero
    var distanceTravelled: Float = .zero

    init() {
        observePublishers()
    }

    func observePublishers() {
        for event in Event.allCases {
            EventManager.shared.registerClosure(event: event, closure: onStatEventRef)
        }
    }

    private lazy var onStatEventRef = { [weak self] (event: Event, eventInfo: EventInfo?) -> Void in
        self?.onStatEvent(event, eventInfo)
    }

    // Update game stats whenever an event is received
    private func onStatEvent(_ event: Event, _ eventInfo: EventInfo?) {
        switch event {
        case .gameEnded:
            AllTimeStats.shared.addStatsFromLatestGame(self)
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
            self.score += Int(score)
        default:
            return
        }
    }
}
