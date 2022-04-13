import PubNub

final class PubNubMessageManager: MessageManager {
    private var pubNub: PubNub?
    private var channels: [String]
    private let listener: SubscriptionListener

    init() {
        self.channels = []
        self.listener = SubscriptionListener(queue: .main)
    }

    var isInitialised: Bool {
        pubNub != nil
    }

    func initialise(playerId: String, channelId: String, messageHandlerDelegate: MessageHandlerDelegate) {
        PubNub.log.levels = [.all]
        PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]
        let config = PubNubConfiguration(publishKey: Constants.pubNubPublishKey,
                                         subscribeKey: Constants.pubNubPublishKey,
                                         uuid: playerId)
        pubNub = PubNub(configuration: config)
        channels.append(channelId)

        listener.didReceiveMessage = { message in
            let payload = message.payload
            let data = payload.jsonData
            messageHandlerDelegate.onReceive(data: data)
        }

        pubNub?.add(listener)
        pubNub?.subscribe(to: channels, withPresence: true)
    }
}
