import CoreGraphics

final class ComboSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
        subscribeToEvents()
    }

    func update(deltaTime: CGFloat) {
        guard let comboComponent = nexus.getComponent(of: ComboComponent.self) else {
            return
        }

        updateElapsedTime(comboComponent, deltaTime: deltaTime)
        resetIfTimeWindowExpired(comboComponent)
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func subscribeToEvents() {
        EventManager.shared.registerClosure(for: EnemyKilledEvent.self, closure: onEnemyKilled)
    }

    private lazy var onEnemyKilled = { [weak self] (_: Event) -> Void in
        guard let comboComponent = self?.nexus.getComponent(of: ComboComponent.self) else {
            return
        }

        self?.accumulate(comboComponent)
    }

    private func accumulate(_ comboComponent: ComboComponent) {
        comboComponent.base += Constants.enemyKilledComboBase
        comboComponent.multiplier += Constants.enemyKilledComboMultiplier
        comboComponent.elapsedTimeSincePreviousAccumulate = .zero
    }

    private func updateElapsedTime(_ comboComponent: ComboComponent, deltaTime: CGFloat) {
        comboComponent.elapsedTimeSincePreviousAccumulate += deltaTime
    }

    private func resetIfTimeWindowExpired(_ comboComponent: ComboComponent) {
        if isTimeWindowExpired(comboComponent) {
            reset(comboComponent)
        }
    }

    private func isTimeWindowExpired(_ comboComponent: ComboComponent) -> Bool {
        comboComponent.elapsedTimeSincePreviousAccumulate > Constants.comboTimeWindow
    }

    private func reset(_ comboComponent: ComboComponent) {
        let comboScore = comboComponent.comboScore
        EventManager.shared.postEvent(ComboExpiredEvent(comboScore: comboScore))

        comboComponent.base = .zero
        comboComponent.multiplier = .zero
        comboComponent.elapsedTimeSincePreviousAccumulate = .zero
    }
}
