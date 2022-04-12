class AllTimeStatsGroup: AchievementGroup {
    var achievementTiers: [Achievement]
    var achievementManagerDelegate: AchievementManagerDelegate

    init(achievementManagerDelegate: AchievementManagerDelegate) {
        self.achievementManagerDelegate = achievementManagerDelegate
        self.achievementTiers = [
            TotalScore(criterion: 500),
            TotalScore(criterion: 1000)
        ]
        subscribeToEvents()
    }

    func subscribeToEvents() {
        EventManager.shared.registerClosureForEvent(of: AllTimeStatsUpdatedEvent.self,
                                                    closure: onAllTimeStatsUpdated)
    }

    private lazy var onAllTimeStatsUpdated = { [weak self] (_ event: Event) -> Void in
        guard let self = self,
              let statUpdateEvent = event as? EnemiesKilledStatUpdateEvent else {
                  return
              }
        self.checkIfCompleted(gameStats: statUpdateEvent.gameStats)
    }
}

extension AllTimeStatsGroup {
    class TotalScore: Achievement {
        var name: String {
            "Earn \(criterion) points across all games"
        }
        var isCompleted = false
        var criterion: Int

        init(criterion: Int) {
            self.criterion = criterion
        }

        func checkIfCompleted(gameStats: GameStats) -> Bool {
            if !isCompleted && AllTimeStats.shared.totalScore >= criterion {
                isCompleted = true
                return true
            }
            return false
        }
    }
}
