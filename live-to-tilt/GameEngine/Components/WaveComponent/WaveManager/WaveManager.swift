import CoreGraphics

protocol WaveManager {
    var waveIterator: AnyIterator<Wave> { get }
    var interval: Interval { get }
    var elapsedTimeSinceLastWave: CGFloat { get set }
}

extension WaveManager {
    mutating func update(nexus: Nexus, deltaTime: CGFloat) {
        elapsedTimeSinceLastWave += deltaTime

        if elapsedTimeSinceLastWave < interval.duration {
            return
        }

        let wave = waveIterator.next()
        wave?.start(nexus: nexus)

        interval.next()
        elapsedTimeSinceLastWave.formTruncatingRemainder(dividingBy: interval.duration)
    }
}
