import CoreGraphics
import Combine

class GameEngine {
    let nexus = Nexus()
    let systems: [System]

    let renderableSubject = PassthroughSubject<[RenderableComponent], Never>()
    var renderablePublisher: AnyPublisher<[RenderableComponent], Never> {
        renderableSubject.eraseToAnyPublisher()
    }

    init() {
        systems = []
    }

    func update(deltaTime: CGFloat, acceleration: LTAcceleration) {
        systems.forEach { $0.update(deltaTime: deltaTime) }

        // Publish updates
        renderableSubject.send(nexus.getComponents(of: RenderableComponent.self))
    }
}
