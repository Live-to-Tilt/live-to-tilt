class AllTimeStatsGroup: AchievementGroup {
    var achievementTiers: [Achievement]
    weak var achievementManagerDelegate: AchievementManagerDelegate?

    init() {
        self.achievementManagerDelegate = nil
        self.achievementTiers = [
            TotalScore(criterion: 100),
            TotalScore(criterion: 1_000),
            TotalScore(criterion: 5_000),
            TotalScore(criterion: 10_000),
            UseAllPowerups(criterion: 5),
            UseAllPowerups(criterion: 10)
        ]
    }

    func subscribeToEvents() {
        EventManager.shared.registerClosureForEvent(of: AllTimeStatsUpdatedEvent.self,
                                                    closure: onAllTimeStatsUpdated)
    }

    private lazy var onAllTimeStatsUpdated = { [weak self] (_ event: Event) -> Void in
        guard let self = self,
              let statUpdateEvent = event as? AllTimeStatsUpdatedEvent else {
                  return
              }
        self.checkIfCompleted(gameStats: nil)
    }
}

extension AllTimeStatsGroup {
    class TotalScore: Achievement {
        var name: String {
            "Earn \(criterion) points across all games"
        }
        var isCompleted = false
        var isRepeatable = false
        var criterion: Int

        init(criterion: Int) {
            self.criterion = criterion
        }

        func checkIfCompleted(gameStats: GameStats?) -> Bool {
            if !isCompleted && AllTimeStats.shared.totalScore >= criterion {
                isCompleted = true
                return true
            }
            return false
        }
    }

    class UseAllPowerups: Achievement {
        var name: String {
            "Use all powerups at least \(criterion) times"
        }
        var isCompleted = false
        var isRepeatable = false
        var criterion: Int

        init(criterion: Int) {
            self.criterion = criterion
        }

        func checkIfCompleted(gameStats: GameStats?) -> Bool {
            if !isCompleted
                && AllTimeStats.shared.totalNukePowerupsUsed >= criterion
                && AllTimeStats.shared.totalLightsaberPowerupsUsed >= criterion
                && AllTimeStats.shared.totalFreezePowerupUsed >= criterion {
                isCompleted = true
                return true
            }
            return false
        }
    }
}
