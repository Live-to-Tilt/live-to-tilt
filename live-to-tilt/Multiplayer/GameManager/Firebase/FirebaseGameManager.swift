import Combine
import FirebaseFirestoreSwift
import Foundation

final class FirebaseGameManager: ObservableObject, GameManager {
    @Published var game: Game?
    var gamePublished: Published<Game?> {
        _game
    }
    var gamePublisher: Published<Game?>.Publisher {
        $game
    }
    private var messageManager: MessageManager

    init() {
        self.messageManager = PubNubMessageManager()
    }

    func createGame(with playerId: String) {
        do {
            let newGame = Game(hostId: playerId)
            game = newGame
            try FirebaseReference(.Game).document(newGame.id).setData(from: newGame)
            initialiseMessanger(playerId: playerId, gameId: newGame.id, isHost: true)
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
                    self.initialiseMessanger(playerId: playerId, gameId: availableGame.id, isHost: false)

                    do {
                        let guestMessage = GuestMessageHandlerDelegate.GuestMessage(message: "Hi, this is a message from the guest!")
                        let data = try JSONEncoder().encode(guestMessage)
                        self.messageManager.send(data: data)
                    } catch {
                        print(error.localizedDescription)
                    }

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

    private func initialiseMessanger(playerId: String, gameId: String, isHost: Bool) {
        if isHost {
            messageManager.initialise(playerId: playerId,
                                      channelId: gameId,
                                      messageHandlerDelegate: GuestMessageHandlerDelegate())
        } else {
            messageManager.initialise(playerId: playerId,
                                      channelId: gameId,
                                      messageHandlerDelegate: HostMessageHandlerDelegate())
        }
    }
}
