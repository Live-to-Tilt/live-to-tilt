import Foundation

final class GameControlManager {
    static let shared = GameControlManager()

    private let defaults: UserDefaults

    var gameControlType: GameControlType {
        guard
            let defaultsValue: String = defaults.string(forKey: .gameControlType),
            let gameControlType = GameControlType(rawValue: defaultsValue)
        else {
            return Constants.defaultGameControl
        }
        return gameControlType
    }
    var gameControl: GameControl {
        switch self.gameControlType {
        case .keyboard:
            return KeyboardControl()
        case .accelerometer:
            return AccelerometerControl()
        }
    }

    private init() {
        defaults = UserDefaults.standard
        defaults.register(defaults: [
            .gameControlType: Constants.defaultGameControl.rawValue
        ])
    }

    func setGameControlType(to newControl: GameControlType) {
        defaults.setValue(newControl.rawValue, forKey: .gameControlType)
    }
}

extension GameControlManager {
    enum GameControlType: String, CaseIterable, Identifiable {
        case accelerometer
        case keyboard

        var id: Self { self }
    }
}
