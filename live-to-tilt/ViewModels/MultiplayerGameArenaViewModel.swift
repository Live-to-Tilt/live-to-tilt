import Combine
import Foundation

class MultiplayerGameArenaViewModel: ObservableObject {
    @Published var game: Game?

    private var cancellables: Set<AnyCancellable>
    private let gameManager: GameManager

    init() {
        self.cancellables = []
        self.gameManager = FirebaseGameManager() // TODO: create factory
    }

    func onAppear() {
        let player = PlayerManager.shared.getPlayer()
        gameManager.startGame(with: player.id)
        gameManager.gamePublisher
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }

    func onDisappear() {
        gameManager.quitGame()
        // TODO: remove cancellables
    }
}
