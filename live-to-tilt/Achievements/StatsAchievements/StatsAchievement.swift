class StatsAchievement {
    let name: String
    let criteria: Int
    var isCompleted: Bool

    init(name: String, criteria: Int) {
        self.name = name
        self.isCompleted = false
        self.criteria = criteria
    }

    func checkIfCompleted(stat: Float) -> Bool {
        false
    }
}
