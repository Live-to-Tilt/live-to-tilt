protocol AchievementGroup {
    var achievementTiers: [Achievement] { get set }
    var achievementManagerDelegate: AchievementManagerDelegate { get set }
    func checkIfCompleted(gameStats: GameStats?)
    func subscribeToEvents()
}

extension AchievementGroup {
    func checkIfCompleted(gameStats: GameStats?) {
        guard let gameStats = gameStats else {
            return
        }
        for achievement in achievementTiers {
            if achievement.checkIfCompleted(gameStats: gameStats) {
                achievementManagerDelegate.achievementIsCompleted(achievement)
            }
        }
    }
}
