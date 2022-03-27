import CoreGraphics

class SurvivalWaveManager: WaveManager {
    let waveIterator: AnyIterator<Wave>
    let interval: Interval
    var elapsedTimeSinceLastWave: CGFloat

    init() {
        let waves: [Wave] = [
            RandomWave()
        ]
        self.waveIterator = waves.makeInfiniteLoopIterator()
        self.interval = ConstantInterval(duration: Constants.survivalWaveIntervalDuration)
        self.elapsedTimeSinceLastWave = .zero
    }
}
