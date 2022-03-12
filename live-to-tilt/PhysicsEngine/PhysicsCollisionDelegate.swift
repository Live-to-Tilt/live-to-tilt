protocol PhysicsCollisionDelegate: AnyObject {

    func didBegin(_ contact: Collision)

    func didEnd(_ contact: Collision)
}
