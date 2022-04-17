import Combine
import Foundation

class MultiplayerLobbyViewModel: ObservableObject {
    @Published var room: Room?
    @Published var displayArena: Bool
    @Published var gameStarting: Bool

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
    private var matchFound: Bool {
        !hostId.isEmpty && !guestId.isEmpty
    }
    private var cancellables: Set<AnyCancellable>

    init() {
        self.cancellables = []
        self.roomManager = FirebaseRoomManager()
        self.messageManager = PubNubMessageManager()
        self.displayArena = false
        self.gameStarting = false
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

        if matchFound && gameStarting {
            // Game has already started
            return
        }

        if matchFound {
            // Start game
            gameStarting = true
            initialiseMessageManager()
            changeToArenaViewAfterDelay()
            return
        }

        gameStarting = false
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
        messageManager.disconnect()
    }
}
