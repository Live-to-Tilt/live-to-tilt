import CoreGraphics

class PlayerComponent: Component {
    let entity: Entity
    var inputForce: CGVector
    let isHost: Bool

    init(entity: Entity, isHost: Bool = true) {
        self.entity = entity
        self.inputForce = .zero
        self.isHost = isHost
    }
}
