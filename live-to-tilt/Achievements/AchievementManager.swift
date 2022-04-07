import SwiftUI

/// AchievementsManager manages achievements that are dependent on game statistics.
/// This can be extended in future to support more event types.
class AchievementManager: ObservableObject {
    @Published var newAchievement: Achievement?

    private let storage: UserDefaults
    private let achievments: [Achievement] = [
        KillEnemies(),
        TotalScore()
    ]

    // TODO: Convert these into Achievements
//    private let achievements: [EventIdentifier: [Int]] = [EnemiesKilledStatUpdatedEvent.identifier: [1, 10, 25, 50],
//                                                .updateNukePowerUpsUsed: [1, 5, 10, 25, 50],
//                                                .updateScore: [100, 250, 500, 1_000, 5_000, 10_000],
//                                                .updateTotalScore: [10_000, 25_000, 50_000, 100_000, 250_000],
//                                                .updateTotalGamesPlayed: [5, 10, 50, 100]
//    ]

    init() {
        self.newAchievement = nil
        self.storage = UserDefaults.standard
        registerAchievements()
        registerClosures()
    }

    func reinit() {
        self.newAchievement = nil
        registerClosures()
    }

    func registerAchievements() {
        var achievementsDict: [String: Bool] = [:]
        achievments.forEach { achievement in
            achievementsDict[achievement.name] = false
        }

        storage.register(defaults: achievementsDict)
    }

    private func registerClosures() {
        EventManager.shared.registerClosureForEvent(of: GameStatsUpdatedEvent.self,
                                                    closure: onGameStatsUpdatedRef)
        EventManager.shared.registerClosureForEvent(of: AllTimeStatsUpdatedEvent.self,
                                                    closure: onAllTimeStatsUpdatedRef)
    }

    private lazy var onGameStatsUpdatedRef = { [weak self] (_ event: Event) -> Void in
        self?.onGameStatsUpdated(event)
    }

    private func onGameStatsUpdated(_ event: Event) {
        guard let gameStatsUpdatedEvent = event as? GameStatsUpdatedEvent else {
            return
        }

        achievments.forEach { achievment in
            if achievment.checkIfCompleted(gameStats: gameStatsUpdatedEvent.gameStats) {
                storage.set(true, forKey: achievment.name)
                newAchievement = achievment
            }
        }
    }

    private lazy var onAllTimeStatsUpdatedRef = { [weak self] (_ event: Event) -> Void in
        self?.onAllTimeStatsUpdated(event)
    }

    private func onAllTimeStatsUpdated(_ event: Event) {
        guard event is AllTimeStatsUpdatedEvent else {
            return
        }

        achievments.forEach { achievment in
            if achievment.checkIfCompleted(gameStats: nil) {
                storage.set(true, forKey: achievment.name)
                newAchievement = achievment
            }
        }
    }
 }
