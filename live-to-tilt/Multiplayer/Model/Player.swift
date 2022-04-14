import Foundation

struct Player: Codable {
    var id: String

    init() {
        id = UUID().uuidString
    }
}
