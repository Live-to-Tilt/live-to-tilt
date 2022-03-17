import CoreGraphics

final class WaveSystem: System {
    var nexus: Nexus
    var elapsedTime: CGFloat

    init(nexus: Nexus) {
        self.nexus = nexus
        self.elapsedTime = 0
    }

    func update(deltaTime: CGFloat) {
        self.elapsedTime += deltaTime

        if self.elapsedTime > Constants.waveIntervalDuration {
            elapsedTime.formTruncatingRemainder(dividingBy: Constants.waveIntervalDuration)
            // spawn wave
        }
    }
}
