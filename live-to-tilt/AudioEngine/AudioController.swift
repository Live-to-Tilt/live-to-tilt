import AVFoundation
import UIKit

final class AudioController {
    static let shared = AudioController()
    var soundtrackVolume: Float {
        defaults.float(forKey: .soundtrackVolume)
    }
    private let defaults: UserDefaults
    private var soundtrackData: [Soundtrack: Data]
    private var soundtrackPlayer: AVAudioPlayer?
    private var currentSoundtrack: Soundtrack?

    private init() {
        defaults = UserDefaults.standard
        soundtrackData = [:]

        defaults.register(defaults: [
            .soundtrackVolume: Constants.defaultSoundtrackVolume
        ])

        for soundtrack in Soundtrack.allCases {
            load(soundtrack)
        }
    }

    func play(_ soundtrack: Soundtrack) {
        if currentSoundtrack == soundtrack {
            return
        }

        if soundtrackPlayer == nil {
            createSoundtrackPlayer(with: soundtrack)
            updateAndPlay(soundtrack)
            return
        }

        fadeOutAndPlay(soundtrack)
    }

    func setSountrackVolume(to volume: Float) {
        soundtrackPlayer?.logarithmicVolume = volume
        defaults.setValue(volume, forKey: .soundtrackVolume)
    }

    private func load(_ soundtrack: Soundtrack) {
        soundtrackData[soundtrack] = NSDataAsset(name: soundtrack.rawValue)?.data
    }

    private func createSoundtrackPlayer(with soundtrack: Soundtrack) {
        guard let data = soundtrackData[soundtrack] else {
            return
        }

        do {
            let volume = UserDefaults.standard.float(forKey: .soundtrackVolume)
            let newPlayer = try AVAudioPlayer(data: data)
            newPlayer.numberOfLoops = -1
            newPlayer.logarithmicVolume = volume
            soundtrackPlayer = newPlayer
        } catch {
            print(error)
        }
    }

    private func updateAndPlay(_ soundtrack: Soundtrack) {
        currentSoundtrack = soundtrack
        soundtrackPlayer?.play()
    }

    private func fadeOutAndPlay(_ soundtrack: Soundtrack) {
        soundtrackPlayer?.setVolume(.zero, fadeDuration: Constants.audioFadeDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.audioFadeDuration) {
            self.createSoundtrackPlayer(with: soundtrack)
            self.updateAndPlay(soundtrack)
        }
    }
}
