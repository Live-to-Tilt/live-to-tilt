import Combine
import FirebaseFirestoreSwift
import Foundation

final class FirebaseRoomManager: ObservableObject, RoomManager {
    @Published var room: Room?
    var roomPublished: Published<Room?> {
        _room
    }
    var roomPublisher: Published<Room?>.Publisher {
        $room
    }
    var isHost: Bool {
        let player = PlayerManager.shared.getPlayer()
        let playerId = player.id
        return playerId == room?.hostId
    }
    private var messageManager: MessageManager

    init() {
        self.messageManager = PubNubMessageManager()
    }

    func joinRoom(with playerId: String) {
        // if there is an available room, join the room
        // else, create new room

        // TODO: remove magic strings

        FirebaseReference(.Room)
            .whereField("guestId", isEqualTo: "")
            .whereField("hostId", isNotEqualTo: playerId)
            .getDocuments { querySnapshot, error in
                if error != nil {
                    self.createGame(with: playerId)
                    return
                }

                if let document = querySnapshot?.documents.first {
                    guard var availableRoom = try? document.data(as: Room.self) else {
                        return
                    }

                    availableRoom.guestId = playerId
                    self.initialiseMessageManager(playerId: playerId, roomId: availableRoom.id)
                    self.room = availableRoom
                    self.updateRoom(availableRoom)
                    self.listenForRoomChanges()
                } else {
                    self.createGame(with: playerId)
                }
            }
    }

    func leaveRoom() {
        guard let room = room else {
            return
        }

        FirebaseReference(.Room).document(room.id).delete()
    }

    func subscribe(messageDelegate: MessageDelegate) {
        messageManager.subscribe(messageDelegate: messageDelegate)
    }

    func send(message: Message) {
        messageManager.send(message: message)
    }

    private func createGame(with playerId: String) {
        do {
            let newRoom = Room(hostId: playerId)
            room = newRoom
            try FirebaseReference(.Room).document(newRoom.id).setData(from: newRoom)
            initialiseMessageManager(playerId: playerId, roomId: newRoom.id)
            listenForRoomChanges()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func updateRoom(_ room: Room) {
        do {
            try FirebaseReference(.Room).document(room.id).setData(from: room)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func listenForRoomChanges() {
        guard let room = room else {
            return
        }

        FirebaseReference(.Room).document(room.id).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                return
            }

            if let snapshot = documentSnapshot {
                self.room = try? snapshot.data(as: Room.self)
            }
        }
    }

    private func initialiseMessageManager(playerId: String, roomId: String) {
        messageManager.initialise(userId: playerId, channelId: roomId)
    }
}
