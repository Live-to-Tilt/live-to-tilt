import Combine
import Foundation

class MultiplayerGameArenaViewModel: ObservableObject {
    @Published var game: Game?

    private var cancellables: Set<AnyCancellable>
    private let playerManager: PlayerManager
    private let multiplayerService: MultiplayerService

    init() {
        self.cancellables = []
        self.playerManager = PlayerManager()
        self.multiplayerService = FService() // TODO: create factory
    }

    func onAppear() {
        let player = playerManager.getPlayer()
        multiplayerService.startGame(with: player.id)
        multiplayerService.gamePublisher
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }

    func onDisappear() {
        multiplayerService.quitGame()
        // TODO: remove cancellables
    }
}
