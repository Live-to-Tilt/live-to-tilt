import Combine
import CoreGraphics
import Foundation

class SettingsViewModel: ObservableObject {
    @Published var soundtrackVolume: CGFloat {
        didSet {
            AudioController.shared.setSoundtrackVolume(to: Float(soundtrackVolume))
        }
    }

    @Published var soundEffectVolume: CGFloat {
        didSet {
            AudioController.shared.setSoundEffectVolume(to: Float(soundEffectVolume))
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
        soundEffectVolume = CGFloat(AudioController.shared.soundEffectVolume)
        sensitivity = CGFloat(GameControlManager.shared.sensitivity)
        gameControlType = GameControlManager.shared.gameControlType
    }
}
