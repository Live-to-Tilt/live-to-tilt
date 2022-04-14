import AVFoundation
import UIKit

final class AudioController: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioController()
    var soundtrackVolume: Float {
        defaults.float(forKey: .soundtrackVolume)
    }
    var soundEffectVolume: Float {
        defaults.float(forKey: .soundEffectVolume)
    }
    private let defaults: UserDefaults

    private var soundtrackData: [Soundtrack: Data]
    private var soundtrackPlayer: AVAudioPlayer?
    private var currentSoundtrack: Soundtrack?

    private var soundEffectData: [SoundEffect: Data]
    private var soundEffectPlayers: [SoundEffect: AVAudioPlayer]
    private var duplicatePlayers: [AVAudioPlayer]

    override private init() {
        defaults = UserDefaults.standard
        soundtrackData = [:]
        soundEffectData = [:]
        soundEffectPlayers = [:]
        duplicatePlayers = []
        super.init()

        defaults.register(defaults: [
            .soundtrackVolume: Constants.defaultVolume,
            .soundEffectVolume: Constants.defaultVolume
        ])

        for soundtrack in Soundtrack.allCases {
            load(soundtrack)
        }

        for soundEffect in SoundEffect.allCases {
            load(soundEffect)
        }
    }

    func play(_ soundtrack: Soundtrack) {
        if currentSoundtrack == soundtrack {
            return
        }

        if soundtrackPlayer == nil {
            playNew(soundtrack)
            return
        }

        fadeOutAndPlay(soundtrack)
    }

    func play(_ soundEffect: SoundEffect) {
        guard let player = soundEffectPlayers[soundEffect] else {
            return
        }

        if player.isPlaying {
            DispatchQueue.global().async {
                self.playUsingDuplicatePlayer(soundEffect)
            }
        }

        let volume = soundEffectVolume
        player.volume = volume
        player.play()
    }

    func setSoundtrackVolume(to volume: Float) {
        soundtrackPlayer?.logarithmicVolume = volume
        defaults.setValue(volume, forKey: .soundtrackVolume)
    }

    func setSoundEffectVolume(to volume: Float) {
        defaults.setValue(volume, forKey: .soundEffectVolume)
    }

    private func load(_ soundtrack: Soundtrack) {
        soundtrackData[soundtrack] = NSDataAsset(name: soundtrack.rawValue)?.data
    }

    private func load(_ soundEffect: SoundEffect) {
        soundEffectData[soundEffect] = NSDataAsset(name: soundEffect.rawValue)?.data

        guard let player = createSoundEffectPlayer(with: soundEffect) else {
            return
        }

        soundEffectPlayers[soundEffect] = player
    }

    private func createSoundtrackPlayer(with soundtrack: Soundtrack) -> AVAudioPlayer? {
        guard let data = soundtrackData[soundtrack] else {
            return nil
        }

        do {
            let volume = soundtrackVolume
            let newPlayer = try AVAudioPlayer(data: data)
            newPlayer.numberOfLoops = -1
            newPlayer.logarithmicVolume = volume
            return newPlayer
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private func createSoundEffectPlayer(with soundEffect: SoundEffect) -> AVAudioPlayer? {
        guard let data = soundEffectData[soundEffect] else {
            return nil
        }

        do {
            let volume = soundEffectVolume
            let newPlayer = try AVAudioPlayer(data: data)
            newPlayer.logarithmicVolume = volume
            return newPlayer
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private func playNew(_ soundtrack: Soundtrack) {
        soundtrackPlayer = createSoundtrackPlayer(with: soundtrack)
        currentSoundtrack = soundtrack
        soundtrackPlayer?.play()
    }

    private func fadeOutAndPlay(_ soundtrack: Soundtrack) {
        soundtrackPlayer?.setVolume(.zero, fadeDuration: Constants.audioFadeDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.audioFadeDuration) {
            self.playNew(soundtrack)
        }
    }

    private func playUsingDuplicatePlayer(_ soundEffect: SoundEffect) {
        if duplicatePlayers.count > Constants.maxDuplicatePlayers {
            return
        }

        guard let duplicatePlayer = createSoundEffectPlayer(with: soundEffect) else {
            return
        }

        duplicatePlayer.delegate = self
        duplicatePlayers.append(duplicatePlayer)
        duplicatePlayer.play()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let index = duplicatePlayers.firstIndex(of: player) else {
            return
        }

        duplicatePlayers.remove(at: index)
    }
}
