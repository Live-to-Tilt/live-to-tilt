import PubNub
import SwiftUI

final class PubNubMessageManager: MessageManager {
    private var pubNub: PubNub?
    private var channels: [String]
    private let listener: SubscriptionListener

    init() {
        self.channels = []
        self.listener = SubscriptionListener()
    }

    var isInitialised: Bool {
        pubNub != nil
    }

    func initialise(playerId: String, channelId: String, messageHandlerDelegate: MessageHandlerDelegate) {
        PubNub.log.levels = [.all]
        PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]
        let config = PubNubConfiguration(publishKey: Constants.pubNubPublishKey,
                                         subscribeKey: Constants.pubNubSubscribeKey,
                                         uuid: playerId)
        pubNub = PubNub(configuration: config)
        channels.append(channelId)

        listener.didReceiveMessage = { message in
            let payload = message.payload
            guard
                let data = payload.dataOptional else {
                return
            }
            messageHandlerDelegate.onReceive(data: data)
        }

        pubNub?.add(listener)
        pubNub?.subscribe(to: channels, withPresence: true)
    }

    func send(data: Data) {
        let jsonString = data.base64EncodedString()

        channels.forEach { channel in
            pubNub?.publish(channel: channel, message: jsonString, completion: nil)
        }
    }
}
