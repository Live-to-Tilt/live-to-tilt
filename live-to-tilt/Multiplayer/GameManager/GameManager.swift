import Combine

protocol GameManager {
    // TODO: Extend to different game modes
    var game: Game? { get }
    var gamePublished: Published<Game?> { get }
    var gamePublisher: Published<Game?>.Publisher { get }

    func startGame(with playerId: String)

    func quitGame()
}
