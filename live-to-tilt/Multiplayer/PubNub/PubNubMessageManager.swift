import PubNub

final class PubNubMessageManager: MessageManager {
    private var pubNub: PubNub?
    var isInitialised: Bool {
        pubNub != nil
    }

    func initialise(playerId: String, channelId: String) {
        PubNub.log.levels = [.all]
        PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]
        let config = PubNubConfiguration(publishKey: Constants.pubNubPublishKey,
                                         subscribeKey: Constants.pubNubPublishKey,
                                         uuid: playerId)
        self.pubNub = PubNub(configuration: config)
    }
}
