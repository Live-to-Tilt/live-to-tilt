import Combine
import SwiftUI

class TenEnemiesKilledAchievement {
    var id: Int
    var name: String
    var isCompleted: Bool {
        didSet {
            if self.isCompleted {
                print("\(self.name) ACHIEVEMENT UNLOCKED!")
            }
        }
    }
    let threshold: Int
    @ObservedObject var gameStats: GameStats
    var enemiesCancellable: AnyCancellable?

    init(id: Int, name: String, gameStats: GameStats) {
        self.id = id
        self.name = name
        self.isCompleted = false
        self.gameStats = gameStats
        self.threshold = 10
        enemiesCancellable = gameStats.$enemiesKilled.sink { [weak self] enemiesKilled in
            self?.checkIfComplete(stat: enemiesKilled)
        }
    }

    func checkIfComplete(stat: Int) {
        if !self.isCompleted && stat >= threshold {
            self.isCompleted = true
        }
    }
}
