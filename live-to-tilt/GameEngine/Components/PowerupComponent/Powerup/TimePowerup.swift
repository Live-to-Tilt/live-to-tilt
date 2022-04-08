import CoreGraphics

class TimePowerup: Powerup {
    var orbImage: ImageAsset
    var activationScore: Int

    init() {
        self.orbImage = .timeOrb
        self.activationScore = .zero
    }

    func coroutine(nexus: Nexus, powerupPosition: CGPoint) {
        guard let countdownComponent = nexus.getComponent(of: CountdownComponent.self) else {
            return
        }

        let updatedTimeLeft = countdownComponent.timeLeft + Constants.gauntletTimeIncreament
        countdownComponent.timeLeft = min(countdownComponent.maxTime, updatedTimeLeft)
    }
}
