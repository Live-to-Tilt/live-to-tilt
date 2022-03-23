class MovementComponent: Component {
    let entity: Entity
    let movement: Movement

    init(entity: Entity, movement: Movement) {
        self.entity = entity
        self.movement = movement
    }
}
