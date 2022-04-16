import Foundation

protocol AchievementGroup: AnyObject {
    var achievementTiers: [Achievement] { get set }
    var achievementManagerDelegate: AchievementManagerDelegate? { get set }
    func subscribeToEvents()
}

extension AchievementGroup {
    func checkIfCompleted(gameStats: GameStats?) {
        achievementTiers.forEach { achievement in
            if achievement.checkIfCompleted(gameStats: gameStats) {
                achievementManagerDelegate?.markAsCompleted(achievement)
            }
        }
    }

    func markCompletedNonRepeatableEvents(storage: UserDefaults) {
        achievementTiers.forEach { achievement in
            if !achievement.isRepeatable && storage.bool(forKey: achievement.name) {
                achievement.isCompleted = true
            }
        }
    }

    func reset() {
        achievementTiers.forEach { achievement in
            achievement.isCompleted = false
        }
    }

    func registerAchievements(storage: UserDefaults) {
        var achievementsDict: [String: Bool] = [:]
        achievementTiers.forEach { achievement in
            achievementsDict[achievement.name] = false
        }
        storage.register(defaults: achievementsDict)
    }

    func getAchievementDisplays(storage: UserDefaults) -> [AchievementDisplay] {
        var achievementDisplays: [AchievementDisplay] = []
        achievementTiers.forEach { achievement in
            achievementDisplays.append(AchievementDisplay(name: achievement.name,
                                                          isCompleted: storage.bool(forKey: achievement.name)))
        }
        return achievementDisplays
    }
}
