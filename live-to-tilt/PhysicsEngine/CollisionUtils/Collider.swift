import CoreGraphics

protocol Collider {
    func checkForCollision(with otherCollider: Collider) -> CollisionPoints

    func checkForCollision(with otherCollider: CircleCollider) -> CollisionPoints

    func checkForCollision(with otherCollider: RectangleCollider) -> CollisionPoints

    func checkForCollision(with otherCollider: TriangleCollider) -> CollisionPoints

}
