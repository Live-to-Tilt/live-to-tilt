import CoreGraphics

class ScoreSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
        subscribeToEvents()
    }

    func update(deltaTime: CGFloat) {}

    func lateUpdate(deltaTime: CGFloat) {}

    private func subscribeToEvents() {
        EventManager.shared.registerClosureForEvent(of: PowerupUsedEvent.self, closure: onGameEvent)
        EventManager.shared.registerClosureForEvent(of: EnemyKilledEvent.self, closure: onGameEvent)
        EventManager.shared.registerClosureForEvent(of: ComboExpiredEvent.self, closure: onGameEvent)
    }

    private lazy var onGameEvent = { [weak self] (event: Event) -> Void in
        guard let deltaScore = self?.getDeltaScoreFromEvent(event) else {
            return
        }

        EventManager.shared.postEvent(ScoreChangedEvent(deltaScore: deltaScore))
    }

    private func getDeltaScoreFromEvent(_ event: Event) -> Int {
        switch event {
        case let powerupUsedEvent as PowerupUsedEvent:
            return powerupUsedEvent.powerup.activationScore
        case _ as EnemyKilledEvent:
            return Constants.enemyKilledScore
        case let comboExpiredEvent as ComboExpiredEvent:
            return comboExpiredEvent.comboScore
        default:
            return .zero
        }
    }
}
