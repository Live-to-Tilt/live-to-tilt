import Combine
import CoreGraphics
import Foundation

class SettingsViewModel: ObservableObject {
    @Published var soundtrackVolume: CGFloat {
        didSet {
            AudioController.instance.setSountrackVolume(to: Float(soundtrackVolume))
        }
    }

    init() {
        soundtrackVolume = CGFloat(AudioController.instance.soundtrackVolume)
    }

    func onAppear() {
        AudioController.instance.play(.theme)
    }
}
