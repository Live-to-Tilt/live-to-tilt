class EnemiesKilledAchievement: StatsAchievement {
    override func checkIfCompleted(gameStats: GameStats) -> Bool {
        if !self.isCompleted && gameStats.enemiesKilled >= self.criteria {
            self.isCompleted = true
            return true
        }
        return false
    }
}
