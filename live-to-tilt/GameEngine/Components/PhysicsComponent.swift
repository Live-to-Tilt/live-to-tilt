class PhysicsComponent: Component {
    let entity: Entity
    var physicsBody: PhysicsBody

    init(entity: Entity, physicsBody: PhysicsBody) {
        self.entity = entity
        self.physicsBody = physicsBody
    }
}
