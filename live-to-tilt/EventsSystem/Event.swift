enum Event: String {
    // game
    case gameStart
    case gameEnd

    // powerups
    case powerUpSpawned

    // collision
    case nukePowerUpUsed // TODO: update after collision System implemented
    case enemyKilled

    // enemy
    case waveStarted
    case enemySpawned

    // player
    case playerMoved
}
