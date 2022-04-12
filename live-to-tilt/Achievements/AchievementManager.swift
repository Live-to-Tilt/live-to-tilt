import SwiftUI
import Combine

/// AchievementsManager manages achievements that are dependent on game statistics.
/// This can be extended in future to support more event types.
class AchievementManager: ObservableObject, AchievementManagerDelegate {
    @Published var newAchievement: Achievement?

    private let storage: UserDefaults
    private let achievementGroups: [AchievementGroup]

    init() {
        self.newAchievement = nil
        self.storage = UserDefaults.standard
        self.achievementGroups = [
            KillEnemiesGroup(),
            AllTimeStatsGroup()
        ]
        registerAchievementManagerDelegate()
        registerAchievements()
        subscribeToEvents()
    }

    func reinit() {
        self.newAchievement = nil
        resetAchievementGroups()
        subscribeToEvents()
    }

    func achievementIsCompleted(_ achievement: Achievement) {
        storage.set(true, forKey: achievement.name)
        newAchievement = achievement
    }

    private func resetAchievementGroups() {
        achievementGroups.forEach { achievementGroup in
            achievementGroup.reset()
        }
    }

    private func subscribeToEvents() {
        achievementGroups.forEach { achievementGroup in
            achievementGroup.subscribeToEvents()
        }
    }

    private func registerAchievementManagerDelegate() {
        for var achievementGroup in achievementGroups {
            achievementGroup.achievementManagerDelegate = self
        }
    }

    private func registerAchievements() {
        var achievementsDict: [String: Bool] = [:]
        achievementGroups.forEach { achievementGroup in
            achievementGroup.achievementTiers.forEach { achievement in
                achievementsDict[achievement.name] = false
            }
        }

        storage.register(defaults: achievementsDict)
    }
 }
