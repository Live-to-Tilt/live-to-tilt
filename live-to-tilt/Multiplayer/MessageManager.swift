import Foundation

protocol MessageManager {
    func initialise(playerId: String, channelId: String, messageHandlerDelegate: MessageHandlerDelegate)

    func send(data: Data)
}
