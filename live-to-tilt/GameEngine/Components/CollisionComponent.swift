import CoreGraphics

class CollisionComponent: Component {
    let entity: Entity
    let collidedEntity: Entity

    init(entity: Entity, collidedEntity: Entity) {
        self.entity = entity
        self.collidedEntity = collidedEntity
    }
}
