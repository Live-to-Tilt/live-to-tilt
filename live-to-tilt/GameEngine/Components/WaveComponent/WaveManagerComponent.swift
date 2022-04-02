import CoreGraphics

class WaveManagerComponent: Component {
    let entity: Entity
    let waveManager: WaveManager

    init(entity: Entity, gameMode: GameMode) {
        self.entity = entity
        switch gameMode {
        case .survival:
            self.waveManager = SurvivalWaveManager()
        case .gauntlet:
            self.waveManager = GauntletWaveManager()
        }
    }
}
