import Foundation

class AchievementsViewModel {
    let achievementManager = AchievementManager()
    var achievements: [AchievementDisplay]

    init() {
        achievements = achievementManager.getAchievementDisplays()
    }
}
