class KillEnemies: Achievement {
    let name: String = "Kill 1 enemy"
    var isCompleted: Bool = false

    func checkIfCompleted(gameStats: GameStats) -> Bool {
        if !isCompleted && gameStats.enemiesKilled >= 1 {
            isCompleted = true
            return true
        }
        return false
    }
}
