protocol AchievementGroup {
    var achievementTiers: [Achievement] { get set }
    var achievementManagerDelegate: AchievementManagerDelegate? { get set }
    func checkIfCompleted(gameStats: GameStats?)
    func subscribeToEvents()
    func reset()
}

extension AchievementGroup {
    func checkIfCompleted(gameStats: GameStats?) {
        for achievement in achievementTiers {
            if achievement.checkIfCompleted(gameStats: gameStats) {
                achievementManagerDelegate?.achievementIsCompleted(achievement)
            }
        }
    }

    func reset() {
        for var achievement in achievementTiers {
            achievement.isCompleted = false
        }
    }
}
