import NotificationCenter

enum StatsKey: String {
    case score
    case numEnemiesKilled
    case numPowerupsUsed
}

extension StatsKey {
    func toNotificationName() -> NSNotification.Name {
        Notification.Name(rawValue: self.rawValue)
    }
}
