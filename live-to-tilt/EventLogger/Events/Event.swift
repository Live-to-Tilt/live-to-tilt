import NotificationCenter

protocol Event {
    static var identifier: EventIdentifier { get }
    var identifier: EventIdentifier { get }
}

extension Event {
    static var identifier: EventIdentifier { EventIdentifier(Self.self) }
    var identifier: EventIdentifier { Self.identifier }
}

extension Event {
    func toNotification() -> Notification {
        Notification(name: self.identifier.notificationName, object: nil, userInfo: ["event": self])
    }
}
