import CoreGraphics

class CollisionComponent: Component {
    let entity: Entity
    let collision: Collision

    init(entity: Entity, collision: Collision) {
        self.entity = entity
        self.collision = collision
    }
}
