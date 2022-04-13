import Combine
import Foundation

class MultiplayerGameArenaViewModel: ObservableObject {
    @Published var game: Game?

    private var cancellables: Set<AnyCancellable>
    private let playerManager: PlayerManager

    init() {
        self.cancellables = []
        self.playerManager = PlayerManager()
    }

    func onAppear() {
        let player = playerManager.getPlayer()
        FService.shared.startGame(with: player.id)
        FService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }

    func onDisappear() {
        FService.shared.quitGame()
        // TODO: remove cancellables
    }
}
