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
    static let survivalWaveIntervalDuration: CGFloat = 5
    static let randomWaveDelay: Double = 0.1
    static let randomWaveEnemyCount: Int = 30
    static let horizontalWaveEnemyCount: Int = 20
    static let gauntletWaveIntervalDuration: CGFloat = 4
    static let gauntletStraightWaveGap: Int = 2

    // Powerups
    static let delayBeforePowerupIsActivatable: Double = 0.5
    static let powerupDiameter: CGFloat = 0.05
    static let powerupRestitution: CGFloat = 1
    static let maxPowerupSpeed: CGFloat = 0.02
    static let survivalPowerupCount: Int = 3

    static let nukeExplosionScale: CGFloat = 8
    static let nukeExplosionAnimationDuration: Double = 0.3
    static let nukeExplosionLifespan: Double = 2

    static let lightsaberLifespan: Double = 4
    static let lightsaberSize = CGSize(width: 0.7, height: 0.02)

    static let freezeBlastScale: CGFloat = 16
    static let freezeBlastAnimationDuration: Double = 0.2
    static let freezeBlastLifespan: Double = 0.5
    static let frozenEnemyDiameter: CGFloat = 0.036
    static let frozenEnemyDuration: CGFloat = 2

    // Enemy Movement
    static let enemyMovementSpeed: CGFloat = 0.1
    static let enemySpawnDelay: CGFloat = 1
    static let enemyLifespan: CGFloat = 30

    // Collision Bitmasks
    static let playerCollisionBitMask: UInt32 = 1 << 0
    static let enemyCollisionBitMask: UInt32 = 1 << 1
    static let wallCollisionBitMask: UInt32 = 1 << 2
    static let powerupCollisionBitMask: UInt32 = 0xFFFFFFF2
    static let timePowerupCollisionBitMask: UInt32 = 0xFFFFFFFE
    static let enemyAffectorCollisionBitMask: UInt32 = 0xFFFFFFFD

    // Combo
    static let comboTimeWindow: CGFloat = 2
    static let enemyKilledComboBase: Int = 6
    static let enemyKilledComboMultiplier: Int = 1

    // Score
    static let enemyKilledScore: Int = 10
    static let nukeActivationScore: Int = 3
    static let lightsaberActivationScore: Int = 8
    static let freezeActivationScore: Int = 8

    // Countdown
    static let gauntletMaxTime: CGFloat = 20
    static let gauntletTimeIncrement: CGFloat = 5
}
