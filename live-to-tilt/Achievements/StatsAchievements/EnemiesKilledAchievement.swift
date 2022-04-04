class EnemiesKilledAchievement: StatsAchievement {
    override func checkIfCompleted(gameStats: GameStats) {
        if !self.isCompleted && gameStats.enemiesKilled > self.criteria {
            self.isCompleted = true
        }
    }
}
