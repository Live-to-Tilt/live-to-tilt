final class Entity: Hashable {
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        let hashValue = ObjectIdentifier(self).hashValue
        hasher.combine(hashValue)
    }
}
