import Foundation

protocol AchievementGroup: AnyObject {
    var achievementTiers: [Achievement] { get set }
    var achievementManagerDelegate: AchievementManagerDelegate? { get set }
    func subscribeToEvents()
}

extension AchievementGroup {
    func checkIfCompleted(gameStats: GameStats?) {
        for achievement in achievementTiers {
            if achievement.checkIfCompleted(gameStats: gameStats) {
                achievementManagerDelegate?.markAsCompleted(achievement)
            }
        }
    }

    func markCompletedNonRepeatableEvents(storage: UserDefaults) {
        for var achievement in achievementTiers {
            if !achievement.isRepeatable && storage.bool(forKey: achievement.name) {
                achievement.isCompleted = true
            }
        }
    }

    func reset() {
        for var achievement in achievementTiers {
            achievement.isCompleted = false
        }
    }
}
