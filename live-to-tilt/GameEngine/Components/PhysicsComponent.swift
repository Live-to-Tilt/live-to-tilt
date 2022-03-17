class PhysicsComponent: Component {
    var physicsBody: PhysicsBody

    init(physicsBody: PhysicsBody) {
        self.physicsBody = physicsBody
    }
}
