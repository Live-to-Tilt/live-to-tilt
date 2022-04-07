class TotalScore: Achievement {
    let name: String = "Earn 5 points across all games"
    var isCompleted = false

    func checkIfCompleted(gameStats: GameStats?) -> Bool {
        if !isCompleted && AllTimeStats.shared.totalScore >= 5 {
            isCompleted = true
            return true
        }
        return false
    }
}
