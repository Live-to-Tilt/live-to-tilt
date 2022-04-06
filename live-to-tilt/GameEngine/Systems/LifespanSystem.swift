import CoreGraphics

final class LifespanSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let lifespanComponents = nexus.getComponents(of: LifespanComponent.self)

        lifespanComponents.forEach { lifespanComponent in
            updateElapsedTime(for: lifespanComponent, deltaTime: deltaTime)
            despawnIfLifespanOver(lifespanComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updateElapsedTime(for lifespanComponent: LifespanComponent, deltaTime: CGFloat) {
        lifespanComponent.elapsedTimeSinceSpawn += deltaTime
    }

    private func despawnIfLifespanOver(_ lifespanComponent: LifespanComponent) {
        if !isLifespanOver(lifespanComponent) {
            return
        }

        let entity = lifespanComponent.entity
        nexus.removeEntity(entity)
    }

    private func isLifespanOver(_ lifespanComponent: LifespanComponent) -> Bool {
        guard let lifespan = lifespanComponent.maxLifespan else {
            return false
        }

        return lifespanComponent.elapsedTimeSinceSpawn > lifespan
    }
}
