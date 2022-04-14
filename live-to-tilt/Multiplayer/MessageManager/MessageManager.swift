protocol MessageManager {
    func initialise(playerId: String, channelId: String)

    func send(message: Message)

    func subscribe(messageHandlerDelegate: MessageHandlerDelegate)
}
