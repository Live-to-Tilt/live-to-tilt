import SwiftUI
class AchievementsManager {
    @ObservedObject var gameStats: GameStats

    var statsToAchievements: [Event: [Achievement]]

    init(gameStats: GameStats) {
        self.gameStats = gameStats
        self.statsToAchievements = [:]
        assignStatsToAchievements()
        registerClosures()
    }

    private func assignStatsToAchievements() {
        self.statsToAchievements[.nukePowerUpsStat] = [NukeAchievement(id: 2, name: "5 Nukes used", threshold: 5)]
    }

    private func registerClosures() {
        EventManager.shared.registerClosure(event: .nukePowerUpsStat, closure: onStatUpdateRef)
    }

    private lazy var onStatUpdateRef = { [weak self] (_ event: Event, eventInfo: [EventInfo: Int]?) -> Void in
        let data = eventInfo
        self?.onStatUpdate(event, eventInfo: eventInfo)
    }

    private func onStatUpdate(_ event: Event, eventInfo: [EventInfo: Int]?) {
        guard let achievements = self.statsToAchievements[event] else {
            return
        }
        for achievement in achievements {
            achievement.checkIfCompleted(gameStats: self.gameStats)
        }
    }
}
