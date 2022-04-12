import SwiftUI

/// AchievementsManager manages achievements that are dependent on game statistics.
/// This can be extended in future to support more event types.
class AchievementManager: ObservableObject, AchievementManagerDelegate {
    @Published var newAchievements: [Achievement] // Change to queue

    private let storage: UserDefaults
    private let achievementGroups: [AchievementGroup]
    private let achievements: [Achievement] = TotalScore()

    // TODO: Convert these into Achievements
//    private let achievements: [AchievementIdentifier: [Int]] = [KillEnemies: [1, 10, 25, 50],
//                                                .updateNukePowerUpsUsed: [1, 5, 10, 25, 50],
//                                                .updateScore: [100, 250, 500, 1_000, 5_000, 10_000],
//                                                .updateTotalScore: [10_000, 25_000, 50_000, 100_000, 250_000],
//                                                .updateTotalGamesPlayed: [5, 10, 50, 100]
//    ]

    init() {
        self.newAchievements = []
        self.storage = UserDefaults.standard
        self.achievementGroups = [
            KillEnemiesGroup(achievementManagerDelegate: self)
        ]
        registerAchievements()
        registerClosures()
    }

    func reinit() {
        self.newAchievements = []
        registerClosures()
    }

    func registerAchievements() {
        var achievementsDict: [String: Bool] = [:]
        achievementGroups.forEach { achievementGroup in
            achievementGroup.achievementTiers.forEach { achievement in
                achievementsDict[achievement.name] = false
            }
        }

        storage.register(defaults: achievementsDict)
    }

    func achievementIsCompleted(_ achievement: Achievement) {
        storage.set(true, forKey: achievement.name)
        newAchievements.append(achievement)
    }

    private func registerClosures() {

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
