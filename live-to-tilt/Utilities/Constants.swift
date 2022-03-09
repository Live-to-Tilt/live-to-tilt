import CoreGraphics

struct Constants {
    // Rendering
    static let framesPerSecond: Int = 60

    // physicsEngine Constants
    static let physicsBodyMinimumSize: CGFloat = 0.05
    static let restitution: CGFloat = 0.8
    static let drag: CGFloat = 0.47

    // Audio
    static let audioFadeDuration: Double = 1
    static let defaultSoundtrackVolume: Float = 1
    static let minSoundtrackVolume: Float = 0
    static let maxSoundtrackVolume: Float = 2
}
