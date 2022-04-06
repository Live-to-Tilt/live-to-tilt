import CoreGraphics

final class AnimationSystem: System {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let animationComponents = nexus.getComponents(of: AnimationComponent.self)

        animationComponents.forEach { animationComponent in
            let animation = animationComponent.animation
            let entity = animationComponent.entity
            animation.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}
}
