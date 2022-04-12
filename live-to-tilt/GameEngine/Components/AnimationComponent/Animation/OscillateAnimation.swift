import CoreGraphics

class OscillateAnimation: Animation {
    var active: Bool
    private let initialPosition: CGPoint
    private let amplitude: CGVector
    private let angularFrequency: CGFloat
    private var elapsedTime: CGFloat

    init(initialPosition: CGPoint, amplitude: CGVector, frequency: CGFloat, active: Bool = true) {
        self.active = active
        self.initialPosition = initialPosition
        self.amplitude = amplitude
        self.angularFrequency = 2 * .pi * frequency
        self.elapsedTime = .zero
    }

    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        guard active else {
            return
        }

        elapsedTime += deltaTime

        let newPosition = initialPosition + amplitude * sin(angularFrequency * elapsedTime)

        let physicsComponents = nexus.getComponents(of: PhysicsComponent.self, for: entity)
        physicsComponents.forEach { physicsComponent in
            physicsComponent.physicsBody.position = newPosition
        }

        let renderableComponents = nexus.getComponents(of: RenderableComponent.self, for: entity)
        renderableComponents.forEach { renderableComponent in
            renderableComponent.position = newPosition
        }
    }
}
