import CoreGraphics

class ComboSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
        subscribeToEvents()
    }

    func update(deltaTime: CGFloat) {
        let comboComponents = nexus.getComponents(of: ComboComponent.self)

        comboComponents.forEach { comboComponent in
            updateElapsedTime(comboComponent, deltaTime: deltaTime)
            resetIfTimeWindowExpired(comboComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}
    
    private func subscribeToEvents() {
        EventManager.shared.registerClosure(event: .enemyKilled, closure: onEnemyKilled)
    }

    private lazy var onEnemyKilled = { [weak self] (_ event: Event, _: [EventInfo: Int]?) -> Void in
        guard let comboComponents = self?.nexus.getComponents(of: ComboComponent.self) else {
            return
        }

        comboComponents.forEach { comboComponent in
            self?.accumulate(comboComponent)
        }
    }
    
    private func accumulate(_ comboComponent: ComboComponent) {
        comboComponent.base += Constants.enemyKilledComboBase
        comboComponent.multiplier += Constants.enemyKilledComboMultiplier
        comboComponent.elapsedTimeSinceComboAccumulatingEvent = .zero
    }

    private func updateElapsedTime(_ comboComponent: ComboComponent, deltaTime: CGFloat) {
        comboComponent.elapsedTimeSinceComboAccumulatingEvent += deltaTime
    }

    private func resetIfTimeWindowExpired(_ comboComponent: ComboComponent) {
        if isTimeWindowExpired(comboComponent) {
            reset(comboComponent)
        }
    }

    private func isTimeWindowExpired(_ comboComponent: ComboComponent) -> Bool {
        comboComponent.elapsedTimeSinceComboAccumulatingEvent > Constants.comboTimeWindow
    }

    private func reset(_ comboComponent: ComboComponent) {
        EventManager.shared.postEvent(.comboExpired,
                                      eventInfo: [.comboScore: comboComponent.base * comboComponent.multiplier])
        
        comboComponent.base = .zero
        comboComponent.multiplier = .zero
        comboComponent.elapsedTimeSinceComboAccumulatingEvent = .zero
    }
}
