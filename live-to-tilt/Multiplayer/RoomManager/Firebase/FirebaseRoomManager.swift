import Combine
import FirebaseFirestoreSwift
import Firebase
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
    private var listener: ListenerRegistration?

    init() {
        self.messageManager = PubNubMessageManager()
    }

    func joinRoom(with playerId: String) {
        // if there is an available room, join the room
        // else, create new room
        FirebaseReference(.Room)
            .whereField("guestId", isEqualTo: "")
            .whereField("hostId", isNotEqualTo: playerId)
            .getDocuments { querySnapshot, error in
                if error != nil {
                    self.createRoom(with: playerId)
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
                    self.createRoom(with: playerId)
                }
            }
    }

    func leaveRoom() {
        guard var room = room else {
            return
        }

        if room.guestId.isEmpty {
            FirebaseReference(.Room).document(room.id).delete()
            return
        }

        if isHost {
            room.hostId = room.guestId
        }

        room.guestId = ""
        updateRoom(room)
        removeListener()
        removeRoom()
    }

    func subscribe(messageDelegate: MessageDelegate) {
        messageManager.subscribe(messageDelegate: messageDelegate)
    }

    func send(message: Message) {
        messageManager.send(message: message)
    }

    private func createRoom(with playerId: String) {
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

        listener = FirebaseReference(.Room).document(room.id).addSnapshotListener(onRoomUpdate)
    }

    private func initialiseMessageManager(playerId: String, roomId: String) {
        messageManager.initialise(userId: playerId, channelId: roomId)
    }

    private func onRoomUpdate(documentSnapshot: DocumentSnapshot?, error: Error?) {
        if error != nil {
            return
        }

        if let snapshot = documentSnapshot {
            guard var room = try? snapshot.data(as: Room.self) else {
                leaveRoom()
                return
            }

            if room.hostId.isEmpty { // opponent leaves
                let player = PlayerManager.shared.getPlayer()
                let playerId = player.id
                room.hostId = playerId
                room.guestId = ""
            }

            self.room = room
        }
    }

    private func removeListener() {
        self.listener?.remove()
        self.listener = nil
    }

    private func removeRoom() {
        self.room = nil
    }
}
