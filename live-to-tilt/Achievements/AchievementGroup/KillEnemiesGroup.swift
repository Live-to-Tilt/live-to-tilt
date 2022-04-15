class KillEnemiesGroup: AchievementGroup {
    weak var achievementManagerDelegate: AchievementManagerDelegate?
    var achievementTiers: [Achievement]

    init() {
        self.achievementTiers = [
            KillEnemies(criterion: 10),
            KillEnemies(criterion: 25),
            KillEnemies(criterion: 50),
            KillEnemies(criterion: 100),
            KillEnemies(criterion: 250),
            KillEnemies(criterion: 1_000)
        ]
    }

    func subscribeToEvents() {
        EventManager.shared.registerClosure(for: EnemiesKilledStatUpdateEvent.self,
                                            closure: onEnemiesKilledStatUpdated)
    }

    private lazy var onEnemiesKilledStatUpdated = { [weak self] (_ event: Event) -> Void in
        guard let self = self,
              let statUpdateEvent = event as? EnemiesKilledStatUpdateEvent else {
                  return
              }
        self.checkIfCompleted(gameStats: statUpdateEvent.gameStats)
    }
}

extension KillEnemiesGroup {
    class KillEnemies: Achievement {
        let criterion: Int
        var isCompleted = false
        let isRepeatable = true
        var name: String {
            "Kill \(criterion.withCommas()) enemies"
        }

        init(criterion: Int) {
            self.criterion = criterion
        }

        func checkIfCompleted(gameStats: GameStats?) -> Bool {
            guard let gameStats = gameStats else {
                return false
            }
            if !isCompleted && gameStats.enemiesKilled >= criterion {
                isCompleted = true
                return true
            }
            return false
        }
    }
}
