import NotificationCenter

enum Event: String, CaseIterable {
    // game
    case gameStarted
    case gameEnded

    // powerups
    case powerUpSpawned

    // collision
    case nukePowerUpUsed
    case enemyKilled

    // enemy
    case waveStarted
    case enemySpawned

    // player
    case playerMoved
}

extension Event {
    func toNotificationName() -> NSNotification.Name {
        Notification.Name(rawValue: self.rawValue)
    }
}
