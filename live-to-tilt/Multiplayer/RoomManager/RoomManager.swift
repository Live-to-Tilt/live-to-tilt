import Combine

protocol RoomManager {
    // TODO: Extend to different game modes
    var room: Room? { get }
    var roomPublished: Published<Room?> { get }
    var roomPublisher: Published<Room?>.Publisher { get }

    var isHost: Bool { get }

    func joinRoom(with playerId: String)

    func leaveRoom()

    func subscribe(messageHandler: MessageDelegate)

    func send(message: Message)
}
