import Combine

protocol RoomManager {
    var room: Room? { get }
    var roomPublished: Published<Room?> { get }
    var roomPublisher: Published<Room?>.Publisher { get }

    var isHost: Bool { get }

    func joinRoom(with playerId: String)

    func leaveRoom()
}
