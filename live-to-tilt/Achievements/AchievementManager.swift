import SwiftUI

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
        setUpAchievementGroups()
    }

    func reinit() {
        self.newAchievement = nil
        resetAchievementGroups()
        setUpAchievementGroups()
    }

    func markAsCompleted(_ achievement: Achievement) {
        storage.set(true, forKey: achievement.name)
        newAchievement = achievement
    }

    private func resetAchievementGroups() {
        achievementGroups.forEach { achievementGroup in
            achievementGroup.reset()
        }
    }

    private func setUpAchievementGroups() {
        achievementGroups.forEach { achievementGroup in
            achievementGroup.subscribeToEvents()
            achievementGroup.markCompletedNonRepeatableEvents(storage: storage)
        }
    }

    private func registerAchievementManagerDelegate() {
        achievementGroups.forEach { achievementGroup in 
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
