import AVFoundation
import UIKit

final class AudioController {
    static let instance = AudioController()
    var soundtrackVolume: Float {
        defaults.float(forKey: .soundtrackVolume)
    }
    private let defaults: UserDefaults
    private var soundtrackData: [Soundtracks: Data]
    private var soundtrackPlayer: AVAudioPlayer?
    private var currentSoundtrack: Soundtracks?

    private init() {
        defaults = UserDefaults.standard
        soundtrackData = [:]

        defaults.register(defaults: [
            .soundtrackVolume: Constants.defaultSoundtrackVolume
        ])

        for soundtrack in Soundtracks.allCases {
            load(soundtrack)
        }
    }

    func play(_ soundtrack: Soundtracks) {
        if currentSoundtrack == soundtrack {
            return
        }

        if soundtrackPlayer == nil {
            createSoundtrackPlayer(with: soundtrack)
            soundtrackPlayer?.play()
            return
        }

        fadeOutAndPlay(soundtrack)
    }

    func setSountrackVolume(to volume: Float) {
        soundtrackPlayer?.logarithmicVolume = volume
        defaults.setValue(volume, forKey: .soundtrackVolume)
    }

    private func load(_ soundtrack: Soundtracks) {
        soundtrackData[soundtrack] = NSDataAsset(name: soundtrack.rawValue)?.data
    }

    private func createSoundtrackPlayer(with soundtrack: Soundtracks) {
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

    private func fadeOutAndPlay(_ soundtrack: Soundtracks) {
        soundtrackPlayer?.setVolume(.zero, fadeDuration: Constants.audioFadeDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.audioFadeDuration) {
            self.createSoundtrackPlayer(with: soundtrack)
            self.soundtrackPlayer?.play()
        }
    }
}
