class NukeAchievement: Achievement {
    override func checkIfCompleted(gameStats: GameStats) {
        if !self.isCompleted && gameStats.nukePowerupsUsed > self.threshold {
            self.isCompleted = true
        }
    }
}
