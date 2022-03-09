import AVFoundation
import UIKit

final class AudioController {
    static let instance = AudioController()
    private let defaults: UserDefaults
    private var soundtrackPlayers: [Soundtracks: AVAudioPlayer]
    private var currentSoundtrackPlayer: AVAudioPlayer?

    private init() {
        defaults = UserDefaults.standard
        soundtrackPlayers = [:]

        defaults.register(defaults: [
            .soundtrackVolume: Constants.defaultSoundtrackVolume
        ])

        for soundtrack in Soundtracks.allCases {
            load(soundtrack)
        }
    }

    func play(_ soundtrack: Soundtracks) {
        guard let soundtrackPlayer = soundtrackPlayers[soundtrack] else {
            return
        }

        if soundtrackPlayer.isPlaying {
            return
        }

        if currentSoundtrackPlayer != nil {
            updateCurrentSoundtrackPlayer(with: soundtrackPlayer)
            return
        }

        currentSoundtrackPlayer = soundtrackPlayer
        soundtrackPlayer.play()
    }

    private func load(_ soundtrack: Soundtracks) {
        guard let data = NSDataAsset(name: soundtrack.rawValue)?.data else {
            return
        }

        do {
            let volume = UserDefaults.standard.float(forKey: .soundtrackVolume)
            let soundtrackPlayer = try AVAudioPlayer(data: data)
            soundtrackPlayer.numberOfLoops = -1
            soundtrackPlayer.volume = volume
            soundtrackPlayers[soundtrack] = soundtrackPlayer
        } catch {
            print(error)
        }
    }

    private func updateCurrentSoundtrackPlayer(with replacement: AVAudioPlayer) {
        guard let soundtrackPlayer = currentSoundtrackPlayer else {
            return
        }

        soundtrackPlayer.setVolume(.zero, fadeDuration: Constants.audioFadeDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.audioFadeDuration) {
            let volume = UserDefaults.standard.float(forKey: .soundtrackVolume)
            soundtrackPlayer.pause()
            soundtrackPlayer.currentTime = .zero
            soundtrackPlayer.setVolume(volume, fadeDuration: .zero)
            replacement.play()
            self.currentSoundtrackPlayer = replacement
        }
    }
}
