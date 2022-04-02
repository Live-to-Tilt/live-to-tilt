class Achievement {
    let id: Int
    let name: String
    var isCompleted: Bool {
        didSet {
            if self.isCompleted {
                print("\(self.name) ACHIEVEMENT UNLOCKED!")
            }
        }
    }
    let threshold: Int

    init(id: Int, name: String, threshold: Int) {
        self.id = id
        self.name = name
        self.isCompleted = false
        self.threshold = threshold
    }

    func checkIfCompleted(gameStats: GameStats) {

    }
}
