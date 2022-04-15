import CoreGraphics

final class CountdownSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let countdownComponents = nexus.getComponents(of: CountdownComponent.self)
        countdownComponents.forEach { countdownComponent in
            updateTimeLeft(countdownComponent, deltaTime: deltaTime)
            updateGameState(countdownComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updateTimeLeft(_ countdownComponent: CountdownComponent, deltaTime: CGFloat) {
        let timeLeft = countdownComponent.timeLeft - deltaTime
        countdownComponent.timeLeft = max(.zero, timeLeft)
    }

    private func updateGameState(_ countdownComponent: CountdownComponent) {
        if !timeIsUp(countdownComponent) {
            return
        }

        let gameStateComponent = nexus.getComponent(of: GameStateComponent.self)
        gameStateComponent?.state = .gameOver
    }

    private func timeIsUp(_ countdownComponent: CountdownComponent) -> Bool {
        let timeLeft = countdownComponent.timeLeft
        return timeLeft == .zero
    }
}
