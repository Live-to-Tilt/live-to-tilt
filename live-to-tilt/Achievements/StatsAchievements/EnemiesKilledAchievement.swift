final class EnemiesKilledAchievement: StatsAchievement {
    override func checkIfCompleted(stat: Float) -> Bool {
        if !self.isCompleted && Int(stat) >= self.criteria {
            self.isCompleted = true
            return true
        }
        return false
    }
}
