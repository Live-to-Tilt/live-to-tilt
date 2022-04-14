import Combine
import Foundation

class MultiplayerLobbyViewModel: ObservableObject {
    @Published var game: Game?
    @Published var displayArena: Bool
    @Published var gameStarted: Bool

    var hostId: String {
        game?.hostId ?? ""
    }
    var guestId: String {
        game?.guestId ?? ""
    }
    private var isMatch: Bool {
        !hostId.isEmpty && !guestId.isEmpty
    }

    private var cancellables: Set<AnyCancellable>
    private let gameManager: GameManager

    init() {
        self.cancellables = []
        self.gameManager = FirebaseGameManager() // TODO: create factory
        self.displayArena = false
        self.gameStarted = false
    }

    func onAppear() {
        let player = PlayerManager.shared.getPlayer()
        gameManager.startGame(with: player.id)
        gameManager.gamePublisher
            .sink { [weak self] game in
                self?.game = game
                self?.updateArenaDisplay()
            }.store(in: &cancellables)
    }

    private func updateArenaDisplay() {
        if game == nil {
            displayArena = false
            return
        }

        if isMatch && gameStarted {
            // Game has already started
            return
        }

        if isMatch {
            // New game
            gameStarted = true
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.displayArenaDelay) {
                self.displayArena = true
            }
            return
        }

        gameStarted = false
        displayArena = false
    }

    deinit {
        gameManager.quitGame()
    }
}
