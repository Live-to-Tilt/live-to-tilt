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
    var roomId: String {
        room?.id ?? ""
    }
    let roomManager: RoomManager
    let messageManager: MessageManager
    private var isMatch: Bool {
        !hostId.isEmpty && !guestId.isEmpty
    }
    private var cancellables: Set<AnyCancellable>

    init() {
        self.cancellables = []
        self.roomManager = FirebaseRoomManager() // TODO: create factory
        self.messageManager = PubNubMessageManager()
        self.displayArena = false
        self.gameStarted = false
    }

    func onAppear() {
        let player = PlayerManager.shared.getPlayer()
        roomManager.joinRoom(with: player.id)
        roomManager.roomPublisher
            .sink { [weak self] room in
                self?.room = room
                self?.updateView()
            }.store(in: &cancellables)
    }

    private func updateView() {
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
            initialiseMessageManager()
            changeToArenaViewAfterDelay()
            return
        }

        gameStarted = false
        displayArena = false
    }

    private func initialiseMessageManager() {
        if roomManager.isHost {
            messageManager.initialise(userId: hostId, channelId: roomId)
        } else {
            messageManager.initialise(userId: guestId, channelId: roomId)
        }
    }

    private func changeToArenaViewAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.displayArenaDelay) {
            self.displayArena = true
        }
    }

    deinit {
        roomManager.leaveRoom()
    }
}
