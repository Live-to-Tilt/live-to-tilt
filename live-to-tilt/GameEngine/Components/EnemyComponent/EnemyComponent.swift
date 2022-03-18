import CoreGraphics

class EnemyComponent: Component {
    let entity: Entity
    private let movement: Movement

    init(entity: Entity, movement: Movement) {
        self.entity = entity
        self.movement = movement
    }

    func updateMovement(deltaTime: CGFloat) {
        movement.update(entity: entity, deltaTime: deltaTime)
    }
}
