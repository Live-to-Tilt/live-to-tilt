import NotificationCenter

// enum Event: String, CaseIterable {
//    // all-time stat updates
//    case updateTotalScore
//    case updateTotalGamesPlayed
// }
//
// extension Event {
//    func toNotificationName() -> Notification.Name {
//        Notification.Name(rawValue: self.rawValue)
//    }
//
//    func toNotification() -> Notification {
//        Notification(name: self.toNotificationName(), object: nil, userInfo: ["event": self])
//    }
// }

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
