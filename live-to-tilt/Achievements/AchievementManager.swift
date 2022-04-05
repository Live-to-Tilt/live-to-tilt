import SwiftUI

/// AchievementsManager manages achievements that are dependent on game statistics.
/// This can be extended in future to support more event types.
class AchievementManager: ObservableObject {
    @Published var newAchievement: StatsAchievement?

    private let storage: UserDefaults
    private var completedAchievements: Set<String>
    private let achievements: [Event: [Int]] = [.updateEnemiesKilled: [1, 10, 25, 50],
                                                .updateNukePowerUpsUsed: [1, 5, 10, 25, 50],
                                                .updateScore: [100, 250, 500, 1_000, 5_000]]
    private var statsToAchievements: [Event: [StatsAchievement]]

    init() {
        self.statsToAchievements = [:]
        self.completedAchievements = []
        self.newAchievement = nil
        self.storage = UserDefaults.standard
        assignStatsToAchievements(self.achievements)
        registerClosures()
    }

    private func assignStatsToAchievements(_ achievements: [Event: [Int]]) {
        var name = ""
        for (statId, criteria) in achievements {
            for criterion in criteria {
                switch statId {
                case .updateEnemiesKilled:
                    name = "Kill \(criterion) enemies"
                    self.statsToAchievements[statId, default: []].append(
                        EnemiesKilledAchievement(name: name, criteria: criterion))
                case .updateNukePowerUpsUsed:
                    name = "Use \(criterion) nuke powerups"
                    self.statsToAchievements[statId, default: []].append(
                        NukeAchievement(name: name, criteria: criterion))
                case .updateScore:
                    name = "Earn \(criterion) points"
                    self.statsToAchievements[statId, default: []].append(
                        ScoreAchievement(name: name, criteria: criterion))
                default:
                    continue
                }
                storage.register(defaults: [name: false])
            }
        }
    }

    private func registerClosures() {
        EventManager.shared.registerClosure(event: .updateEnemiesKilled, closure: onStatUpdateRef)
        EventManager.shared.registerClosure(event: .updateNukePowerUpsUsed, closure: onStatUpdateRef)
        EventManager.shared.registerClosure(event: .updateScore, closure: onStatUpdateRef)
    }

    private lazy var onStatUpdateRef = { [weak self] (_ updatedStat: Event, eventInfo: EventInfo?) -> Void in
        self?.onStatUpdate(updatedStat, eventInfo: eventInfo)
    }

    private func onStatUpdate(_ updatedStat: Event, eventInfo: EventInfo?) {
        guard let achievements = self.statsToAchievements[updatedStat],
              let stat = eventInfo?[.statValue] else {
            return
        }
        for achievement in achievements {
            if !completedAchievements.contains(where: { $0 == achievement.name })
                && achievement.checkIfCompleted(stat: stat) {
                self.storage.set(true, forKey: achievement.name)
                newAchievement = achievement
                completedAchievements.insert(achievement.name)
            }
        }
    }
}
