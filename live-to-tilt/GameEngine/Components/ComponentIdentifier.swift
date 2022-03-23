struct ComponentIdentifier: Hashable {
    private let id: Int

    init<T: Component>(_ componentType: T.Type) {
        self.id = ObjectIdentifier(componentType).hashValue
    }
}
