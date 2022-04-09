import CoreGraphics

class GauntletWaveManager: WaveManager {
    private let waveIterator: AnyIterator<Wave>
    private let intervalIterator: AnyIterator<CGFloat>
    private var currentInterval: CGFloat
    private var elapsedTimeSinceLastWave: CGFloat

    init() {
        let waves: [Wave] = [
            GauntletStraightWave()
        ]
        let intervals: [CGFloat] = [
            Constants.gauntletWaveIntervalDuration
        ]
        self.waveIterator = waves.makeInfiniteLoopIterator()
        self.intervalIterator = intervals.makeInfiniteLoopIterator()
        self.currentInterval = .zero
        self.elapsedTimeSinceLastWave = .zero
    }

    func update(deltaTime: CGFloat) {
        elapsedTimeSinceLastWave += deltaTime
    }

    func canStartNextWave(nexus: Nexus) -> Bool {
        elapsedTimeSinceLastWave > currentInterval
    }

    func startNextWave(nexus: Nexus) {
        let wave = waveIterator.next()
        wave?.start(nexus: nexus)

        resetElapsedTime()
    }

    private func resetElapsedTime() {
        guard let nextInterval = intervalIterator.next() else {
            return
        }

        currentInterval = nextInterval
        elapsedTimeSinceLastWave = .zero
    }
}
