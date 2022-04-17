import CoreGraphics

class GauntletWaveSpawner: WaveSpawner {
    private let waveIterator: AnyIterator<Wave>
    private let intervalIterator: AnyIterator<CGFloat>
    private var currentInterval: CGFloat
    private var elapsedTimeSinceLastWave: CGFloat

    init() {
        let waves: [Wave] = [
            GapWave(gapWidths: [Constants.gauntletSmallGapWidth, Constants.gauntletLargeGapWidth])
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

    func canSpawnNextWave(nexus: Nexus) -> Bool {
        elapsedTimeSinceLastWave > currentInterval
    }

    func spawnNextWave(nexus: Nexus) {
        let wave = waveIterator.next()
        wave?.spawn(nexus: nexus)

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
