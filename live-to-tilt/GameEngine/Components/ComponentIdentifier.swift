struct ComponentIdentifier: Hashable {
    typealias Identifier = Int
    let id: Identifier

    init<T: Component>(_ componentType: T.Type) {
        self.id = ObjectIdentifier(componentType).hashValue
    }
}
