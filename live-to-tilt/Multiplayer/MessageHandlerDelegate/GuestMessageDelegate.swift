import Foundation

class GuestMessageDelegate: MessageDelegate {
    func onReceive(data: Data) {
        do {
            let guestMessage = try JSONDecoder().decode(GuestMessage.self, from: data)
            print(guestMessage.message)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension GuestMessageDelegate {
    struct GuestMessage: Codable {
        let message: String
    }
}
