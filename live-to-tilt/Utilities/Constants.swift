import CoreGraphics

struct Constants {
    // Rendering
    static let framesPerSecond: Int = 60
    static let gameArenaAspectRatio: Double = 1.5
    static let gameArenaHeight: Double = 1.0

    // Audio
    static let audioFadeDuration: Double = 1
    static let defaultSoundtrackVolume: Float = 1
    static let minSoundtrackVolume: Float = 0
    static let maxSoundtrackVolume: Float = 2

    // Colors
    static let primaryBackgroundColorRGB: [Double] = [171 / 255, 196 / 255, 255 / 255]
    static let secondaryBackgroundColorRGB: [Double] = [182 / 255, 204 / 255, 254 / 255]
    static let foregroundColorRGB: [Double] = [237 / 255, 242 / 255, 251 / 255]

    // Game Control
    static let defaultGameControl: GameControlManager.GameControlType = .accelerometer
    static let defaultSensitivity: CGFloat = 2.2

    // Entities
    static let playerSpawnPosition = CGPoint(x: 0.75, y: 0.5)
    static let playerSize = CGSize(width: 0.03, height: 0.045)
    static let enemyDiameter: CGFloat = 0.03
    static let enemyFrontToBackRatio: CGFloat = 0.8

    // Wave
    static let waveIntervalDuration: CGFloat = 10
    static let randomWaveDelay: Double = 0.1
    static let randomWaveEnemyCount: Int = 10

    // Powerups
    static let powerupSpawnInterval: CGFloat = 7
    static let delayBeforePowerupIsActivatable: Double = 0.5
    static let powerupDiameter: CGFloat = 0.05
    static let maxNumberOfPowerupsInArena: Int = 3
    static let nukeExplosionDiameter: CGFloat = 0.8
    static let nukeExplosionDuration: Double = 0.5

    // Enemy Movement
    static let homingMovementVelocity: CGFloat = 1
}
