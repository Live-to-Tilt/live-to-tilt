class LightsaberPowerup: Powerup {
    let orbImage: ImageAsset
    let activationScore: Int = Constants.lightsaberActivationScore

    init() {
        self.orbImage = .lightsaberOrb
    }

    func coroutine(nexus: Nexus) {
        nexus.createLightsaberAura()
    }
}
