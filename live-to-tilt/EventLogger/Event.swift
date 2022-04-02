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

    // Stats
    case enemiesKilledStat
    case nukePowerUpsStat
}

extension Event {
    func toNotificationName() -> Notification.Name {
        Notification.Name(rawValue: self.rawValue)
    }
}
