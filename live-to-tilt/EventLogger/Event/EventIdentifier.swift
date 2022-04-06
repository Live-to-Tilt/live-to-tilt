import Foundation

struct EventIdentifier: Hashable {
    private let id: Int
    let notificationName: Notification.Name

    init<T: Event>(_ eventType: T.Type) {
        self.id = ObjectIdentifier(eventType).hashValue
        self.notificationName = Notification.Name(String(self.id))
    }
}
