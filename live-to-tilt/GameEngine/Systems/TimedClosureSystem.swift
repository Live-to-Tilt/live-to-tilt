import CoreGraphics

final class TimedClosureSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let timedClosureComponents = nexus.getComponents(of: TimedClosureComponent.self)

        timedClosureComponents.forEach { timedClosureComponent in
            updateTimeLeft(for: timedClosureComponent, deltaTime: deltaTime)
            evaluateClosure(for: timedClosureComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updateTimeLeft(for timedClosureComponent: TimedClosureComponent, deltaTime: CGFloat) {
        timedClosureComponent.timeLeft -= deltaTime
    }

    private func evaluateClosure(for timedClosureComponent: TimedClosureComponent) {
        if timedClosureComponent.timeLeft <= 0 {
            timedClosureComponent.closure()
        }
    }
}
