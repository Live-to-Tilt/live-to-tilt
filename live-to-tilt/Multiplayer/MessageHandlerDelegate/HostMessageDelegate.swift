import Combine
import Foundation

class HostMessageDelegate: MessageDelegate, ObservableObject {
    private let messageBuffer: MessageBuffer

    init(messageBuffer: MessageBuffer) {
        self.messageBuffer = messageBuffer
    }

    func onReceive(data: Data) {
        do {
            let message = try JSONDecoder().decode(HostMessage.self, from: data)
            messageBuffer.insert(message: message)
        } catch {
            print(error.localizedDescription)
        }
    }
}
