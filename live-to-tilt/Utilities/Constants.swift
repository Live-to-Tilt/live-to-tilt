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

    // Game Control
    static let defaultSensitivity: Float = 1
    static let minSensitivity: Float = 0.5
    static let maxSensitivity: Float = 1.5
    static let defaultGameControl: GameControlManager.GameControlType = .accelerometer

    // Game Engine
    static let defaultTimeScale: CGFloat = 1.0

    // Entities
    static let topWallPosition = CGPoint(x: 0.75, y: -0.05)
    static let bottomWallPosition = CGPoint(x: 0.75, y: 1.05)
    static let leftWallPosition = CGPoint(x: -0.05, y: 0.5)
    static let rightWallPosition = CGPoint(x: 1.55, y: 0.5)
    static let horizontalWallSize = CGSize(width: 1.5, height: 0.1)
    static let verticalWallSize = CGSize(width: 0.1, height: 1)
    static let playerSpawnPosition = CGPoint(x: 0.75, y: 0.5)
    static let playerSize = CGSize(width: 0.045, height: 0.03)
    static let playerColliderSize = CGSize(width: 0.03, height: 0.03)
    static let enemyDiameter: CGFloat = 0.03
    static let enemyFrontToBackRatio: CGFloat = 0.8

    // Wave
    static let survivalWaveIntervalDuration: CGFloat = 10
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
    static let homingMovementVelocity: CGFloat = 0.1

    // Collision Bitmasks
    static let playerCollisionBitMask: UInt32 = 1 << 0
    static let enemyCollisionBitMask: UInt32 = 1 << 1
    static let powerUpBitMask: UInt32 = 1 << 2
    static let wallCollisionBitMask: UInt32 = 1 << 3
}
