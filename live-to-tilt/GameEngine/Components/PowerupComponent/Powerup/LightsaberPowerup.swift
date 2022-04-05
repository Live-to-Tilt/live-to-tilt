class LightsaberPowerup: Powerup {
    let orbImage: ImageAsset

    init() {
        self.orbImage = .lightsaberOrb
    }

    func coroutine(nexus: Nexus) {
        nexus.createLightsaberAura()
    }
}
