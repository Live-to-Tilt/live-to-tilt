import Foundation

class AchievementsViewModel: ObservableObject {
    let achievementManager = AchievementManager()
    @Published var achievements: [AchievementDisplay]

    init() {
        achievements = achievementManager.getAchievementDisplays()
    }
}
