import NotificationCenter

extension Notification.Name {
    init(event: Event) {
        self.init(rawValue: event.rawValue)
    }
}
