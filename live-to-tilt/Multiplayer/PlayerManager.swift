import Foundation

class PlayerManager {
    static let shared = PlayerManager()

    private let defaults: UserDefaults
    private let playerData: Data?

    private init() {
        self.defaults = UserDefaults.standard
        self.playerData = defaults.data(forKey: .player)
    }

    func getPlayer() -> Player {
        guard let data = playerData else {
            let player = createNewPlayer()
            return player
        }

        do {
            let player = try JSONDecoder().decode(Player.self, from: data)
            return player
        } catch {
            let player = createNewPlayer()
            return player
        }
    }

    private func save(_ player: Player) {
        do {
            let data = try JSONEncoder().encode(player)
            defaults.setValue(data, forKey: .player)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func createNewPlayer() -> Player {
        let player = Player()
        save(player)
        return player
    }
}
