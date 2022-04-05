import NotificationCenter

enum Event: String, CaseIterable {
    // game
    case gameStarted
    case gameEnded

    // powerups
    case powerUpSpawned

    // collision
    case nukePowerupUsed
    case lightsaberPowerupUsed
    case enemyKilled

    // enemy
    case waveStarted
    case enemySpawned

    // player
    case playerMoved

    // combo
    case comboExpired

    // score
    case scoreChanged

    // stat updates
    case updateEnemiesKilled
    case updateNukePowerUpsUsed
    case updateScore
}

extension Event {
    func toNotificationName() -> Notification.Name {
        Notification.Name(rawValue: self.rawValue)
    }
}
