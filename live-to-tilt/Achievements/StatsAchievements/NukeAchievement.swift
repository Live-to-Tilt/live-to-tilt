class NukeAchievement: StatsAchievement {
    override func checkIfCompleted(gameStats: GameStats) {
        if !self.isCompleted && gameStats.nukePowerupsUsed > self.criteria {
            self.isCompleted = true
        }
    }
}
