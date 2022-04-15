import CoreGraphics

class PlayerComponent: Component {
    let entity: Entity
    var inputForce: CGVector
    let isPlayerOne: Bool

    init(entity: Entity, isPlayerOne: Bool = true) {
        self.entity = entity
        self.inputForce = .zero
        self.isPlayerOne = isPlayerOne
    }
}
