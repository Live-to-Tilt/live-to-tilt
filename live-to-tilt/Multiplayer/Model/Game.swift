import Foundation
struct Game: Codable {
    let id: String
    var hostId: String
    var guestId: String

    init(hostId: String) {
        self.id = UUID().uuidString
        self.hostId = hostId
        self.guestId = ""
    }
}
