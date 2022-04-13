import Foundation

class GuestMessageHandlerDelegate: MessageHandlerDelegate {
    func onReceive(data: Data) {
        do {
            let guestMessage = try JSONDecoder().decode(GuestMessage.self, from: data)
            print(guestMessage.message)
        } catch {
            print(error.localizedDescription)
        }
    }
}
