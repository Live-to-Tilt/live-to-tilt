import CoreGraphics

class ComboSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
        observePublishers()
    }

    func update(deltaTime: CGFloat) {
        let comboComponents = nexus.getComponents(of: ComboComponent.self)

        comboComponents.forEach { comboComponent in
            updateElapsedTime(comboComponent, deltaTime: deltaTime)
            resetIfTimeWindowExpired(comboComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updateElapsedTime(_ comboComponent: ComboComponent, deltaTime: CGFloat) {
        comboComponent.elapsedTimeSinceComboMaintainingEvent += deltaTime
    }

    private func resetIfTimeWindowExpired(_ comboComponent: ComboComponent) {
        if isTimeWindowExpired(comboComponent) {
            reset(comboComponent)
        }
    }

    private func isTimeWindowExpired(_ comboComponent: ComboComponent) -> Bool {
        comboComponent.elapsedTimeSinceComboMaintainingEvent > Constants.comboTimeWindow
    }

    private func reset(_ comboComponent: ComboComponent) {
        comboComponent.base = .zero
        comboComponent.multiplier = .zero
        comboComponent.elapsedTimeSinceComboMaintainingEvent = .zero
    }

    private func observePublishers() {
        EventManager.shared.registerClosure(event: .enemyKilled, closure: onEnemyKilled)
    }

    private lazy var onEnemyKilled = { [weak self] (_ event: Event, _: [EventInfo: Int]?) -> Void in
        guard let comboComponents = self?.nexus.getComponents(of: ComboComponent.self) else {
            return
        }

        comboComponents.forEach { comboComponent in
            self?.updateScore(comboComponent)
        }
    }

    private func updateScore(_ comboComponent: ComboComponent) {
        comboComponent.base += Constants.enemyKilledComboScore
        comboComponent.multiplier += 1
    }
}
