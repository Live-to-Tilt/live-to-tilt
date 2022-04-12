protocol Achievement {
    var name: String { get }
    var isCompleted: Bool { get set }

    func checkIfCompleted(gameStats: GameStats) -> Bool
}
