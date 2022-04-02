import CoreGraphics

class MovementDecorator: Movement {
    private let movement: Movement

    init(movement: Movement) {
        self.movement = movement
    }

    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        movement.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
    }
}
