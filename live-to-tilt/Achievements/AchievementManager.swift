import SwiftUI

/// AchievementsManager manages achievements that are dependent on game statistics.
/// This can be extended in future to support more event types.
class AchievementManager: ObservableObject {
    @Published var newAchievement: StatsAchievement?

    private var completedAchievements: Set<Int>

    private var gameStats: GameStats

    private let achievements: [StatId: [Int]] = [.enemiesKilled: [1, 10, 25, 50],
                                                 .nukePowerUpsUsed: [1, 5, 10, 25, 50],
                                                 .score: [100, 250, 500, 1_000, 5_000]]

    private var statsToAchievements: [StatId: [StatsAchievement]]

    init(gameStats: GameStats) {
        self.gameStats = gameStats
        self.statsToAchievements = [:]
        self.completedAchievements = []
        self.newAchievement = nil
        assignStatsToAchievements(self.achievements)
        registerClosures()
    }

    private func assignStatsToAchievements(_ achievements: [StatId: [Int]]) {
        var id = 0
        for (statId, criteria) in achievements {
            for criterion in criteria {
                switch statId {
                case .enemiesKilled:
                    self.statsToAchievements[statId, default: []].append(
                        EnemiesKilledAchievement(id: id, name: "Kill \(criterion) enemies", criteria: criterion))
                case .nukePowerUpsUsed:
                    self.statsToAchievements[statId, default: []].append(
                        NukeAchievement(id: id, name: "Use \(criterion) nuke powerups", criteria: criterion))
                case .score:
                    self.statsToAchievements[statId, default: []].append(
                        ScoreAchievement(id: id, name: "Earn \(criterion) points", criteria: criterion))
                }
                id += 1
            }
        }
    }

    private func registerClosures() {
        gameStats.registerClosure(for: .enemiesKilled, closure: onStatUpdateRef)
        gameStats.registerClosure(for: .nukePowerUpsUsed, closure: onStatUpdateRef)
        gameStats.registerClosure(for: .score, closure: onStatUpdateRef)
    }

    private lazy var onStatUpdateRef = { [weak self] (_ statId: StatId) -> Void in
        self?.onStatUpdate(statId)
    }

    private func onStatUpdate(_ statId: StatId) {
        guard let achievements = self.statsToAchievements[statId] else {
            return
        }
        for achievement in achievements {
            if !completedAchievements.contains(where: { $0 == achievement.id })
                && achievement.checkIfCompleted(gameStats: self.gameStats) {
                newAchievement = achievement
                completedAchievements.insert(achievement.id)
            }
        }
    }
}
