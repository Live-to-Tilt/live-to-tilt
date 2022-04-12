class KillEnemiesGroup: AchievementGroup {
    var achievementManagerDelegate: AchievementManagerDelegate
    var achievementTiers: [Achievement]

    init(achievementManagerDelegate: AchievementManagerDelegate) {
        self.achievementManagerDelegate = achievementManagerDelegate
        self.achievementTiers = [
            KillEnemiesTier(criterion: 10),
            KillEnemiesTier(criterion: 25),
            KillEnemiesTier(criterion: 50),
            KillEnemiesTier(criterion: 100),
            KillEnemiesTier(criterion: 250),
            KillEnemiesTier(criterion: 1000),
        ]
        subscribeToEvents()
    }

    func subscribeToEvents() {
        EventManager.shared.registerClosureForEvent(of: EnemiesKilledStatUpdateEvent.self,
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
    class KillEnemiesTier: Achievement {
        var criterion: Int
        var isCompleted = false
        var name: String {
            "Kill \(criterion) enemies"
        }

        init(criterion: Int) {
            self.criterion = criterion
        }

        func checkIfCompleted(gameStats: GameStats) -> Bool {
            if !isCompleted && gameStats.enemiesKilled >= criterion {
                isCompleted = true
                return true
            }
            return false
        }
    }
}
