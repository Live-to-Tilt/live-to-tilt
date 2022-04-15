import Combine
import Foundation

class MultiplayerLobbyViewModel: ObservableObject {
    @Published var room: Room?
    @Published var displayArena: Bool
    @Published var gameStarted: Bool

    var hostId: String {
        room?.hostId ?? ""
    }
    var guestId: String {
        room?.guestId ?? ""
    }
    let roomManager: RoomManager
    private var isMatch: Bool {
        !hostId.isEmpty && !guestId.isEmpty
    }
    private var cancellables: Set<AnyCancellable>

    init() {
        self.cancellables = []
        self.roomManager = FirebaseRoomManager() // TODO: create factory
        self.displayArena = false
        self.gameStarted = false
    }

    func onAppear() {
        let player = PlayerManager.shared.getPlayer()
        roomManager.joinRoom(with: player.id)
        roomManager.roomPublisher
            .sink { [weak self] room in
                self?.room = room
                self?.updateArenaDisplay()
            }.store(in: &cancellables)
    }

    private func updateArenaDisplay() {
        if room == nil {
            displayArena = false
            return
        }

        if isMatch && gameStarted {
            // Game has already started
            return
        }

        if isMatch {
            // Start game
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
        roomManager.leaveRoom()
    }
}
