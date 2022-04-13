import Combine
import FirebaseFirestoreSwift

final class FService: ObservableObject {
    @Published var game: Game?
    static let shared = FService()

    private init() { }

    func createGame(with playerId: String) {
        do {
            let newGame = Game(hostId: playerId)
            game = newGame
            try FirebaseReference(.Game).document(newGame.id).setData(from: newGame)
            listenForGameChanges()
        } catch {
            print(error.localizedDescription)
        }
    }

    func startGame(with playerId: String) {
        // if there is an available game, join the game
        // else, create new game

        // TODO: remove magic strings

        FirebaseReference(.Game)
            .whereField("guestId", isEqualTo: "")
            .whereField("hostId", isNotEqualTo: playerId)
            .getDocuments { querySnapshot, error in
                if error != nil {
                    self.createGame(with: playerId)
                    return
                }

                if let document = querySnapshot?.documents.first {
                    guard var availableGame = try? document.data(as: Game.self) else {
                        return
                    }

                    availableGame.guestId = playerId
                    self.game = availableGame
                    self.updateGame(availableGame)
                    self.listenForGameChanges()
                } else {
                    self.createGame(with: playerId)
                }
            }
    }

    func updateGame(_ game: Game) {
        do {
            try FirebaseReference(.Game).document(game.id).setData(from: game)
        } catch {
            print(error.localizedDescription)
        }
    }

    func listenForGameChanges() {
        guard let currentGame = game else {
            return
        }

        FirebaseReference(.Game).document(currentGame.id).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                return
            }

            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: Game.self)
            }
        }
    }

    func quitGame() {
        guard let currentGame = game else {
            return
        }

        FirebaseReference(.Game).document(currentGame.id).delete()
    }
}
