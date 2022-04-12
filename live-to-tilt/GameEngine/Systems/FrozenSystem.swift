import CoreGraphics

final class FrozenSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let frozenComponents = nexus.getComponents(of: FrozenComponent.self)

        frozenComponents.forEach { frozenComponent in
            updateTimeLeft(for: frozenComponent, deltaTime: deltaTime)
            unfreeze(frozenComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func updateTimeLeft(for frozenComponent: FrozenComponent, deltaTime: CGFloat) {
        frozenComponent.timeLeft -= deltaTime
    }

    private func unfreeze(_ frozenComponent: FrozenComponent) {
        if frozenComponent.timeLeft <= .zero {
            let entity = frozenComponent.entity
            nexus.removeComponents(of: FrozenComponent.self, for: entity)
            nexus.removeComponents(of: AnimationComponent.self, for: entity)
            nexus.removeComponents(of: RenderableComponent.self, for: entity)
            frozenComponent.initialRenderables.forEach { renderableComponent in
                nexus.addComponent(renderableComponent, to: entity)
            }
        }
    }
}
