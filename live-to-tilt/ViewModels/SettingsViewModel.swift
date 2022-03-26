import Combine
import CoreGraphics
import Foundation

class SettingsViewModel: ObservableObject {
    @Published var soundtrackVolume: CGFloat {
        didSet {
            AudioController.shared.setSountrackVolume(to: Float(soundtrackVolume))
        }
    }

    @Published var sensitivity: CGFloat {
        didSet {
            GameControlManager.shared.setSensitivity(to: Float(sensitivity))
        }
    }

    @Published var gameControlType: GameControlManager.GameControlType {
        didSet {
            GameControlManager.shared.setGameControlType(to: gameControlType)
        }
    }

    init() {
        soundtrackVolume = CGFloat(AudioController.shared.soundtrackVolume)
        sensitivity = CGFloat(GameControlManager.shared.sensitivity)
        gameControlType = GameControlManager.shared.gameControlType
    }
}
