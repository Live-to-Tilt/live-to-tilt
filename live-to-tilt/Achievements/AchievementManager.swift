// import SwiftUI
//
///// AchievementsManager manages achievements that are dependent on game statistics.
///// This can be extended in future to support more event types.
// class AchievementManager: ObservableObject {
//    @Published var newAchievement: StatsAchievement?
//
//    private let storage: UserDefaults
//    private var completedAchievements: Set<String>
//    private let achievements: [Event: [Int]] = [.updateEnemiesKilled: [1, 10, 25, 50],
//                                                .updateNukePowerUpsUsed: [1, 5, 10, 25, 50],
//                                                .updateScore: [100, 250, 500, 1_000, 5_000, 10_000],
//                                                .updateTotalScore: [10_000, 25_000, 50_000, 100_000, 250_000],
//                                                .updateTotalGamesPlayed: [5, 10, 50, 100]
//    ]
//    private var statsToAchievements: [Event: [StatsAchievement]]
//
//    init() {
//        self.completedAchievements = []
//        self.newAchievement = nil
//        self.storage = UserDefaults.standard
//        self.statsToAchievements = [:]
//        assignStatsToAchievements(self.achievements)
//        registerClosures()
//    }
//
//    func reinit() {
//        self.completedAchievements = []
//        self.newAchievement = nil
//        self.statsToAchievements = [:]
//        assignStatsToAchievements(self.achievements)
//        registerClosures()
//    }
//
//    private func assignStatsToAchievements(_ achievements: [Event: [Int]]) {
//        var name = ""
//        for (statId, criteria) in achievements {
//            for criterion in criteria {
//                switch statId {
//                case .updateEnemiesKilled:
//                    name = "Kill \(criterion) enemies"
//                case .updateNukePowerUpsUsed:
//                    name = "Use \(criterion) nuke powerups"
//                case .updateScore:
//                    name = "Earn \(criterion) points"
//                case .updateTotalScore:
//                    name = "Earn \(criterion) points across all games"
//                case .updateTotalGamesPlayed:
//                    name = "Play \(criterion) games"
//                default:
//                    continue
//                }
//                self.statsToAchievements[statId, default: []].append(
//                    StatsAchievement(name: name, criteria: criterion))
//                storage.register(defaults: [name: false])
//            }
//        }
//    }
//
//    private func registerClosures() {
//        EventManager.shared.registerClosure(event: .updateEnemiesKilled, closure: onStatUpdateRef)
//        EventManager.shared.registerClosure(event: .updateNukePowerUpsUsed, closure: onStatUpdateRef)
//        EventManager.shared.registerClosure(event: .updateScore, closure: onStatUpdateRef)
//        EventManager.shared.registerClosure(event: .updateTotalScore, closure: onAllTimeStatUpdateRef)
//        EventManager.shared.registerClosure(event: .updateTotalGamesPlayed, closure: onAllTimeStatUpdateRef)
//    }
//
//    private lazy var onStatUpdateRef = { [weak self] (_ updatedStat: Event, eventInfo: EventInfo?) -> Void in
//        self?.onStatUpdate(updatedStat, eventInfo: eventInfo)
//    }
//
//    private func onStatUpdate(_ updatedStat: Event, eventInfo: EventInfo?) {
//        guard let achievements = self.statsToAchievements[updatedStat],
//              let stat = eventInfo?[.statValue] else {
//            return
//        }
//        for achievement in achievements {
//            if !completedAchievements.contains(where: { $0 == achievement.name })
//                && achievement.checkIfCompleted(stat: stat) {
//                storage.set(true, forKey: achievement.name)
//                newAchievement = achievement
//                completedAchievements.insert(achievement.name)
//            }
//        }
//    }
//
//    private lazy var onAllTimeStatUpdateRef = { [weak self] (_ updatedStat: Event, eventInfo: EventInfo?) -> Void in
//        self?.onAllTimeStatUpdate(updatedStat, eventInfo: eventInfo)
//    }
//
//    private func onAllTimeStatUpdate(_ updatedStat: Event, eventInfo: EventInfo?) {
//        guard let achievements = self.statsToAchievements[updatedStat],
//              let stat = eventInfo?[.statValue] else {
//            return
//        }
//        for achievement in achievements {
//            if !storage.bool(forKey: achievement.name)
//                && achievement.checkIfCompleted(stat: stat) {
//                storage.set(true, forKey: achievement.name)
//                newAchievement = achievement
//            }
//        }
//    }
// }
