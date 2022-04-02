import CoreGraphics

class ComboSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
        subscribeToEvents()
    }

    func update(deltaTime: CGFloat) {
        guard let gameStateComponent = nexus.getComponent(of: GameStateComponent.self) else {
            return
        }
        
        updateElapsedTime(gameStateComponent, deltaTime: deltaTime)
        resetComboIfTimeWindowExpired(gameStateComponent)
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func subscribeToEvents() {
        EventManager.shared.registerClosure(event: .enemyKilled, closure: onEnemyKilled)
    }

    private lazy var onEnemyKilled = { [weak self] (_ event: Event, eventInfo: [EventInfo: Int]?) -> Void in
        guard let gameStateComponent = self?.nexus.getComponent(of: GameStateComponent.self) else {
            return
        }
        
        self?.accumulateCombo(gameStateComponent)
    }

    private func accumulateCombo(_ gameStateComponent: GameStateComponent) {
        gameStateComponent.comboBase += Constants.enemyKilledComboBase
        gameStateComponent.comboMultiplier += Constants.enemyKilledComboMultiplier
        gameStateComponent.elapsedTimeSincePreviousComboAccumulate = .zero
    }

    private func updateElapsedTime(_ gameStateComponent: GameStateComponent, deltaTime: CGFloat) {
        gameStateComponent.elapsedTimeSincePreviousComboAccumulate += deltaTime
    }

    private func resetComboIfTimeWindowExpired(_ gameStateComponent: GameStateComponent) {
        if isComboTimeWindowExpired(gameStateComponent) {
            resetCombo(gameStateComponent)
        }
    }

    private func isComboTimeWindowExpired(_ gameStateComponent: GameStateComponent) -> Bool {
        gameStateComponent.elapsedTimeSincePreviousComboAccumulate > Constants.comboTimeWindow
    }

    private func resetCombo(_ gameStateComponent: GameStateComponent) {
        let comboScore = gameStateComponent.comboBase * gameStateComponent.comboMultiplier
        EventManager.shared.postEvent(.comboExpired,
                                      eventInfo: [.deltaScore: comboScore])

        gameStateComponent.comboBase = .zero
        gameStateComponent.comboMultiplier = .zero
        gameStateComponent.elapsedTimeSincePreviousComboAccumulate = .zero
    }
}
