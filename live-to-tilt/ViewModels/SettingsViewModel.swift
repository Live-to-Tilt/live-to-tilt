import Combine
import CoreGraphics
import Foundation

class SettingsViewModel: ObservableObject {
    @Published var soundtrackVolume: CGFloat {
        didSet {
            AudioController.shared.setSountrackVolume(to: Float(soundtrackVolume))
        }
    }

    init() {
        soundtrackVolume = CGFloat(AudioController.shared.soundtrackVolume)
    }

    func onAppear() {
        AudioController.shared.play(.theme)
    }
}
