import PubNub
import SwiftUI

final class PubNubMessageManager: MessageManager {
    private var pubNub: PubNub?
    private var channels: [String]
    private let listener: SubscriptionListener
    private var messageDelegates: [MessageDelegate]

    init() {
        self.channels = []
        self.listener = SubscriptionListener()
        self.messageDelegates = []
    }

    var isInitialised: Bool {
        pubNub != nil
    }

    func initialise(userId: String, channelId: String) {
        PubNub.log.levels = [.none]
        PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]

        guard
            let publishKey = Bundle.main.secret(secretsKey: .PN_PUBLISH_KEY),
            let subscribeKey = Bundle.main.secret(secretsKey: .PN_SUBSCRIBE_KEY) else {
                return
            }

        let config = PubNubConfiguration(publishKey: publishKey,
                                         subscribeKey: subscribeKey,
                                         uuid: userId)
        pubNub = PubNub(configuration: config)
        channels.append(channelId)

        listener.didReceiveMessage = publishMessage

        pubNub?.add(listener)
        pubNub?.subscribe(to: channels, withPresence: true)
    }

    func send(message: Message) {
        do {
            let data = try JSONEncoder().encode(message)
            let jsonString = data.base64EncodedString()

            channels.forEach { channel in
                pubNub?.publish(channel: channel, message: jsonString, completion: nil)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func subscribe(messageDelegate: MessageDelegate) {
        messageDelegates.append(messageDelegate)
    }

    func disconnect() {
        pubNub?.disconnect()
        listener.cancel()
        pubNub = nil
        channels = []
        messageDelegates = []
    }

    private func publishMessage(message: PubNubMessage) {
        let payload = message.payload
        guard
            let data = payload.dataOptional else {
            return
        }
        self.messageDelegates.forEach { messageDelegate in
            messageDelegate.onReceive(data: data)
        }
    }
}
