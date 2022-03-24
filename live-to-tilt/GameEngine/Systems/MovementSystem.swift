import CoreGraphics

final class MovementSystem: System {
    let nexus: Nexus
    var events: [Event : Int]

    init(nexus: Nexus) {
        self.nexus = nexus
        self.events = [:]
    }

    func update(deltaTime: CGFloat) {
        let movementComponents = nexus.getComponents(of: MovementComponent.self)
        movementComponents.forEach { movementComponent in
            let entity = movementComponent.entity
            let movement = movementComponent.movement
            movement.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
        }
        postEvents()
    }
}
