class KillEnemies: Achievement {
    let name: String = "Kill 1 enemy"
    var isCompleted = false

    func checkIfCompleted(gameStats: GameStats?) -> Bool {
        guard let gameStats = gameStats else {
            return false
        }

        if !isCompleted && gameStats.enemiesKilled >= 1 {
            isCompleted = true
            return true
        }
        return false
    }
}
