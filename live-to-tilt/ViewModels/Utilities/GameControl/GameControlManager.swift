import Foundation

final class GameControlManager {
    static let shared = GameControlManager()

    private let defaults: UserDefaults

    var sensitivity: Float {
        defaults.float(forKey: .sensitivity)
    }
    var logarithmicSensitivity: Float {
        pow(sensitivity, 2)
    }
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
            return KeyboardControl(sensitivity: logarithmicSensitivity)
        case .accelerometer:
            return AccelerometerControl(sensitivity: logarithmicSensitivity)
        }
    }

    private init() {
        defaults = UserDefaults.standard
        defaults.register(defaults: [
            .gameControlType: Constants.defaultGameControl.rawValue,
            .sensitivity: Constants.defaultSensitivity
        ])
    }

    func setSensitivity(to newSensitivity: Float) {
        defaults.setValue(newSensitivity, forKey: .sensitivity)
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
