struct Collision {
    let bodyA: PhysicsBody
    let bodyB: PhysicsBody
    let collisionPoints: CollisionPoints
}

extension Collision: Hashable { }
