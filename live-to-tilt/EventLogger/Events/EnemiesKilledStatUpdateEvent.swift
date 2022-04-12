class EnemiesKilledStatUpdateEvent: Event {
    let gameStats: GameStats

    init(gameStats: GameStats) {
        self.gameStats = gameStats
    }
}
