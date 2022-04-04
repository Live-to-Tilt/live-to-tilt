class NukeAchievement: StatsAchievement {
    override func checkIfCompleted(gameStats: GameStats) -> Bool {
        if !self.isCompleted && gameStats.nukePowerupsUsed >= self.criteria {
            self.isCompleted = true
            return true
        }
        return false
    }
}
