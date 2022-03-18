class PowerupComponent: Component {
    let entity: Entity
    var elapsedTimeSinceSpawn: Double = 0
    private(set) var isActive = false

    private var canActivate: Bool {
        self.elapsedTimeSinceSpawn > Constants.delayBeforePowerupIsActivatable
    }

    init(entity: Entity) {
        self.entity = entity
    }

    func activate() {
        guard canActivate else {
            return
        }

        self.isActive = true
    }
}
