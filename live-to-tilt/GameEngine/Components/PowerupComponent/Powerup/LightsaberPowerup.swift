class LightsaberPowerup: Powerup {
    let image: ImageAsset

    init() {
        self.image = .lightsaberOrb
    }

    func coroutine(nexus: Nexus) {
        nexus.createLightsaberAura()
    }
}
