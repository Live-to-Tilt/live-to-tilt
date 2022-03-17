import CoreGraphics

final class WaveSystem: System {
    let nexus: Nexus
    private let waves: [Wave]
    private var elapsedTime: CGFloat
    private var pointer: Int

    init(nexus: Nexus) {
        self.nexus = nexus
        self.waves = [
            RandomWave(nexus: nexus)
        ]
        self.elapsedTime = 0
        self.pointer = 0
    }

    func update(deltaTime: CGFloat) {
        self.elapsedTime += deltaTime

        if self.elapsedTime > Constants.waveIntervalDuration {
            resetElapsedTime()
            spawnWave()
            updatePointer()
        }
    }

    private func resetElapsedTime() {
        elapsedTime.formTruncatingRemainder(dividingBy: Constants.waveIntervalDuration)
    }

    private func spawnWave() {
        if waves.isEmpty {
            return
        }

        let wave = waves[pointer]
        wave.start()
    }

    private func updatePointer() {
        if waves.isEmpty {
            return
        }

        pointer = (pointer + 1) % waves.count
    }
}
