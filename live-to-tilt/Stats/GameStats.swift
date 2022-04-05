import CoreGraphics
import Foundation

/**
 Manages the statistics of the current game.
 */
class GameStats {
    private var observerClosures: [StatId: [(StatId) -> Void]]
    private let gameMode: GameMode
    private(set) var score: Int = .zero {
        didSet {
            onUpdateStat(statId: .score)
        }
    }
    private(set) var powerupsUsed: Int = .zero
    private(set) var nukePowerupsUsed: Int = .zero {
        didSet {
            onUpdateStat(statId: .nukePowerUpsUsed)
        }
    }
    private(set) var lightsaberPowerupsUsed: Int = .zero
    private(set) var enemiesKilled: Int = .zero {
        didSet {
            onUpdateStat(statId: .enemiesKilled)
        }
    }
    private(set) var distanceTravelled: Float = .zero
    private(set) var playTime: Float = .zero

    init(gameMode: GameMode) {
        self.gameMode = gameMode
        self.observerClosures = [:]
        observePublishers()
    }

    func incrementPlayTime(deltaTime: CGFloat) {
        playTime += Float(deltaTime)
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

    private func observePublishers() {
        for event in Event.allCases {
            EventManager.shared.registerClosure(event: event, closure: onStatEventRef)
        }
    }

    private lazy var onStatEventRef = { [weak self] (event: Event, eventInfo: EventInfo?) -> Void in
        self?.onStatEvent(event, eventInfo)
    }

    /// Update game stats based on the received event
    ///
    /// - Parameters:
    ///   - event: type of event received
    ///   - eventInfo: event info received
    private func onStatEvent(_ event: Event, _ eventInfo: EventInfo?) {
        switch event {
        case .gameEnded:
            AllTimeStats.shared.addStatsFromLatestGame(self, gameMode)
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

    func getBackdropValue() -> String {
        switch gameMode {
        case .survival:
            return score.withCommas()
        case .gauntlet:
            return playTime.toTimeString()
        }
    }

    func getGameOverStats() -> [GameOverStat] {
        var stats: [GameOverStat] = []

        switch gameMode {
        case .survival:
            stats.append(GameOverStat(label: "Score", value: score.withCommas()))
            stats.append(GameOverStat(label: "Time", value: playTime.toTimeString()))
            stats.append(GameOverStat(label: "Dead Dots", value: enemiesKilled.withCommas()))
        case .gauntlet:
            stats.append(GameOverStat(label: "Time", value: playTime.toTimeString()))
        }

        return stats
    }
}
