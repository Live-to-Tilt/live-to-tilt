protocol MessageManager {
    func initialise(playerId: String, channelId: String, messageHandlerDelegate: MessageHandlerDelegate)
}
