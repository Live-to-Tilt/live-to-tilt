import NotificationCenter

extension Notification.Name {
    init(systemId: SystemIdentifier) {
        self.init(rawValue: String(systemId.id))
    }
}
