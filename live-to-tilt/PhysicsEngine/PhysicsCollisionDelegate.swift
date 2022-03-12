protocol PhysicsCollisionDelegate: AnyObject {

    func didBegin(_ collision: Collision)

    func didEnd(_ collision: Collision)
}
