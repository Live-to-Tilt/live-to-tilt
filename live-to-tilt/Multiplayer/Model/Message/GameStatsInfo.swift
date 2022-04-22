struct GameStatsInfo: Codable {
    let gameMode: GameMode
    var score: Int = .zero
    var powerupsDespawned: Int = .zero
    var powerupsUsed: Int = .zero
    var nukePowerupsUsed: Int = .zero
    var lightsaberPowerupsUsed: Int = .zero
    var freezePowerupsUsed: Int = .zero
    var enemiesKilled: Int = .zero
    var distanceTravelled: Float = .zero
    var playTime: Float = .zero
    var wave: Int = .zero

    init?(gameStats: GameStats?) {
        guard let gameStats = gameStats else {
            return nil
        }
        self.gameMode = gameStats.gameMode
        self.score = gameStats.score
        self.powerupsDespawned = gameStats.powerupsDespawned
        self.powerupsUsed = gameStats.powerupsUsed
        self.nukePowerupsUsed = gameStats.nukePowerupsUsed
        self.lightsaberPowerupsUsed = gameStats.lightsaberPowerupsUsed
        self.freezePowerupsUsed = gameStats.freezePowerupsUsed
        self.enemiesKilled = gameStats.enemiesKilled
        self.distanceTravelled = gameStats.distanceTravelled
        self.playTime = gameStats.playTime
        self.wave = gameStats.wave
    }

    func toGameStats() -> GameStats {
        GameStats(gameMode: gameMode,
                  score: score,
                  powerupsDespawned: powerupsDespawned,
                  powerupsUsed: powerupsUsed,
                  nukePowerupsUsed: nukePowerupsUsed,
                  lightsaberPowerupsUsed: lightsaberPowerupsUsed,
                  freezePowerupsUsed: freezePowerupsUsed,
                  enemiesKilled: enemiesKilled,
                  distanceTravelled: distanceTravelled,
                  playTime: playTime,
                  wave: wave)
    }
}

extension GameMode: Codable { }
