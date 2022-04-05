import CoreGraphics

class CountdownSystem: System {
    var nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let timerComponents = nexus.getComponents(of: CountdownComponent.self)
        timerComponents.forEach { timerComponent in
            updateTimeLeft(timerComponent, deltaTime: deltaTime)
            updateGameState(timerComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {

    }

    private func updateTimeLeft(_ timerComponent: CountdownComponent, deltaTime: CGFloat) {
        let timeLeft = timerComponent.timeLeft - deltaTime
        timerComponent.timeLeft = max(.zero, timeLeft)
    }

    private func updateGameState(_ timerComponent: CountdownComponent) {
        if !timeIsUp(timerComponent) {
            return
        }

        let gameStateComponent = nexus.getComponent(of: GameStateComponent.self)
        gameStateComponent?.state = .gameOver
    }

    private func timeIsUp(_ timerComponent: CountdownComponent) -> Bool {
        let timeLeft = timerComponent.timeLeft
        return timeLeft == .zero
    }
}
