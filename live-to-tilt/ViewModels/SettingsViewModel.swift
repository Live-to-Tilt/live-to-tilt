import Combine
import CoreGraphics
import Foundation

class SettingsViewModel: ObservableObject {
    @Published var soundtrackVolume: CGFloat {
        didSet {
            AudioController.shared.setSountrackVolume(to: Float(soundtrackVolume))
        }
    }

    @Published var gameControlType: GameControlManager.GameControlType {
        didSet {
            GameControlManager.shared.setGameControlType(to: gameControlType)
        }
    }

    init() {
        soundtrackVolume = CGFloat(AudioController.shared.soundtrackVolume)
        gameControlType = GameControlManager.shared.gameControlType
    }
}
