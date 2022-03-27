import CoreGraphics

class GauntletWaveManager: WaveManager {
    private let waveIterator: AnyIterator<Wave>
    private let interval: Interval
    private var elapsedTimeSinceLastWave: CGFloat

    init() {
        let waves: [Wave] = [
            RandomWave()
        ]
        self.waveIterator = waves.makeInfiniteLoopIterator()
        self.interval = ConstantInterval(duration: Constants.survivalWaveIntervalDuration)
        self.elapsedTimeSinceLastWave = .zero
    }

    func update(deltaTime: CGFloat) {
        elapsedTimeSinceLastWave += deltaTime
    }

    func canStartNextWave(nexus: Nexus) -> Bool {
        elapsedTimeSinceLastWave > interval.duration
    }

    func startNextWave(nexus: Nexus) {
        let wave = waveIterator.next()
        wave?.start(nexus: nexus)
    }

    private func resetElapsedTime() {
        interval.next()
        elapsedTimeSinceLastWave.formTruncatingRemainder(dividingBy: interval.duration)
    }
}
