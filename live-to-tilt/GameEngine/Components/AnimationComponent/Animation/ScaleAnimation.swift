import CoreGraphics

class ScaleAnimation: Animation {
    var active: Bool
    private let deltaWidthTotal: CGFloat
    private let deltaHeightTotal: CGFloat
    private let duration: CGFloat
    private var elapsedTime: CGFloat

    init(initialSize: CGSize, scale: CGFloat, duration: CGFloat, active: Bool = true) {
        self.active = active
        self.deltaWidthTotal = initialSize.width * scale - initialSize.width
        self.deltaHeightTotal = initialSize.height * scale - initialSize.height
        self.duration = duration
        self.elapsedTime = .zero
    }

    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        if elapsedTime > duration {
            return
        }

        if !active {
            return
        }

        elapsedTime += deltaTime

        let deltaSize = calculateDeltaSize(from: deltaTime)

        let physicComponents = nexus.getComponents(of: PhysicsComponent.self, for: entity)
        physicComponents.forEach { physicsComponent in
            scalePhysicsComponent(physicsComponent, deltaSize: deltaSize)
        }

        let renderableComponents = nexus.getComponents(of: RenderableComponent.self, for: entity)
        renderableComponents.forEach { renderableComponent in
            scaleRenderableComponent(renderableComponent, deltaSize: deltaSize)
        }
    }

    private func calculateDeltaSize(from deltaTime: CGFloat) -> CGSize {
        let timeFraction = deltaTime / duration
        let deltaWidth = deltaWidthTotal * timeFraction
        let deltaHeight = deltaHeightTotal * timeFraction
        let deltaSize = CGSize(width: deltaWidth, height: deltaHeight)
        return deltaSize
    }

    private func scalePhysicsComponent(_ physicsComponent: PhysicsComponent, deltaSize: CGSize) {
        let physicsBody = physicsComponent.physicsBody
        physicsBody.size += deltaSize
    }

    private func scaleRenderableComponent(_ renderableComponent: RenderableComponent, deltaSize: CGSize) {
        renderableComponent.size += deltaSize
    }
}
