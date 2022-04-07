class TotalScore: Achievement {
    let name: String = "Earn 10,000 points across all games"
    var isCompleted = false

    func checkIfCompleted(gameStats: GameStats?) -> Bool {
        if !isCompleted && AllTimeStats.shared.totalScore >= 10_000 {
            isCompleted = true
            return true
        }
        return false
    }
}
