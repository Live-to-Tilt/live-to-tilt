import CoreGraphics

class PowerupComponent: Component {
    let entity: Entity
    let effect: PowerupEffect
    private(set) var isActive = false
    private var elapsedTimeSinceSpawn: Double = 0

    private var canActivate: Bool {
        self.elapsedTimeSinceSpawn > Constants.delayBeforePowerupIsActivatable
    }

    init(entity: Entity, effect: PowerupEffect) {
        self.entity = entity
        self.effect = effect
    }

    func activate() {
        guard canActivate else {
            return
        }

        self.isActive = true
    }

    func update(for deltaTime: CGFloat) {
        self.elapsedTimeSinceSpawn += deltaTime

        if isActive {
            self.effect.update(for: deltaTime)
        }
    }
}
