class StatsAchievement {
    let id: Int
    let name: String
    let criteria: Int
    var isCompleted: Bool

    init(id: Int, name: String, criteria: Int) {
        self.id = id
        self.name = name
        self.isCompleted = false
        self.criteria = criteria
    }

    func checkIfCompleted(gameStats: GameStats) -> Bool {
        false
    }
}
