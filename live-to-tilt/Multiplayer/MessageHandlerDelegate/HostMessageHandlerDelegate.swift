import Foundation

class HostMessageHandlerDelegate: MessageHandlerDelegate {
    func onReceive(data: Data) {
        do {
            let hostMessage = try JSONDecoder().decode(HostMessage.self, from: data)
            print(hostMessage.message)
        } catch {
            print(error.localizedDescription)
        }
    }
}
