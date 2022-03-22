import NotificationCenter

enum StatsKey: String {
    case score = "score"
    case numEnemiesKilled = "currEnemiesKilled"
    case numPowerupsUsed = "numPowerupsUsed"
}

extension StatsKey {
    func toNotificationName() -> NSNotification.Name {
        Notification.Name(rawValue: self.rawValue)
    }
}
