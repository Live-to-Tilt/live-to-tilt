protocol Achievement: AnyObject {
    var name: String { get }
    var isCompleted: Bool { get set }
    var isRepeatable: Bool { get }

    func checkIfCompleted(gameStats: GameStats?) -> Bool
}
