import CoreGraphics

class PowerupManagerComponent: Component {
    let entity: Entity
    let powerupManager: PowerupManager

    init(entity: Entity, gameMode: GameMode) {
        self.entity = entity
        switch gameMode {
        case .survival:
            self.powerupManager = SurvivalPowerupManager()
        case .gauntlet:
            self.powerupManager = GauntletPowerupManager()
        }
    }
}
