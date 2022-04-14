protocol MessageManager {
    func initialise(userId: String, channelId: String)

    func send(message: Message)

    func subscribe(messageHandlerDelegate: MessageHandlerDelegate)
}
