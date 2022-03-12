protocol Collider {
    func checkCollision(with otherCollider: Collider) -> CollisionPoints

    func checkCollision(with otherCollider: CircleCollider) -> CollisionPoints

    func checkCollision(with otherCollider: RectangleCollider) -> CollisionPoints
}
