class GameStatsUpdatedEvent: Event {
    let gameStats: GameStats

    init(gameStats: GameStats) {
        self.gameStats = gameStats
    }
}
