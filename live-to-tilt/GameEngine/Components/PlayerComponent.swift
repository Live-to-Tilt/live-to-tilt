import CoreGraphics

class PlayerComponent: Component {
    let entity: Entity
    var inputForce: CGVector

    init(entity: Entity) {
        self.entity = entity
        self.inputForce = .zero
    }
}
