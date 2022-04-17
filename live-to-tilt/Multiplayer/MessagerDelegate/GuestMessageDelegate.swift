import Foundation

class GuestMessageDelegate: MessageDelegate {
    private let messageBuffer: MessageBuffer

    init(messageBuffer: MessageBuffer) {
        self.messageBuffer = messageBuffer
    }

    func onReceive(data: Data) {
        do {
            let guestMessage = try JSONDecoder().decode(GuestMessage.self, from: data)
            messageBuffer.insert(message: guestMessage)
        } catch {
            print(error.localizedDescription)
        }
    }
}
