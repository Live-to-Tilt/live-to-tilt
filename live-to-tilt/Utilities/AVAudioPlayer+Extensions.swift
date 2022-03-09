import AVFoundation

extension AVAudioPlayer {
    var logarithmicVolume: Float {
        get {
            sqrt(volume)
        }
        set {
            volume = pow(newValue, 2)
        }
    }
}
