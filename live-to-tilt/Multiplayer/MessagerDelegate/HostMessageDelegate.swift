import Combine
import Foundation

class HostMessageDelegate: MessageDelegate, ObservableObject {
    private let messageBuffer: MessageBuffer

    init(messageBuffer: MessageBuffer) {
        self.messageBuffer = messageBuffer
    }

    func onReceive(data: Data) {
        do {
            let hostMessage = try JSONDecoder().decode(HostMessage.self, from: data)
            messageBuffer.insert(message: hostMessage)
        } catch {
            print(error.localizedDescription)
        }
    }
}
