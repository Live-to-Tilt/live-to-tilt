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
        EventManager.shared.registerClosure(event: .enemyKilled, closure: onGameEvent)
        EventManager.shared.registerClosure(event: .nukePowerupUsed, closure: onGameEvent)
        EventManager.shared.registerClosure(event: .lightsaberPowerupUsed, closure: onGameEvent)
        EventManager.shared.registerClosure(event: .comboExpired, closure: onGameEvent)
    }

    private lazy var onGameEvent = { [weak self] (_ event: Event, eventInfo: [EventInfo: Int]?) -> Void in
        guard let gameStateComponent = self?.nexus.getComponent(of: GameStateComponent.self),
              let deltaScore = self?.getDeltaScoreFromEvent(event, eventInfo: eventInfo) else {
            return
        }

        gameStateComponent.score += deltaScore
        EventManager.shared.postEvent(.scoreChanged,
                                      eventInfo: [.deltaScore: deltaScore])
    }

    private func getDeltaScoreFromEvent(_ event: Event, eventInfo: [EventInfo: Int]?) -> Int {
        switch event {
        case .enemyKilled:
            return Constants.enemyKilledScore
        case .nukePowerupUsed:
            return Constants.nukeActivationScore
        case .lightsaberPowerupUsed:
            return Constants.lightsaberActivationScore
        case .comboExpired:
            let comboScore = eventInfo?[.deltaScore] ?? .zero
            return comboScore
        default:
            return .zero
        }
    }
}
