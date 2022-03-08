import Foundation

final class Entity: Identifiable {
    let id: String

    init() {
        self.id = UUID().uuidString
    }
}

extension Entity: Hashable {
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
