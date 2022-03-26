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
    func toNotificationName() -> Notification.Name {
        Notification.Name(rawValue: self.rawValue)
    }

    static func fromNotificationName(_ notificationName: Notification.Name) -> Event? {
        for event in Event.allCases {
            if event.toNotificationName() == notificationName {
                return event
            }
        }
        return nil
    }
}
