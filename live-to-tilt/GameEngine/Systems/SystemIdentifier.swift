struct SystemIdentifier: Hashable {
    let id: Int

    init<T: System>(_ systemType: T.Type) {
        self.id = ObjectIdentifier(systemType).hashValue
    }
}
