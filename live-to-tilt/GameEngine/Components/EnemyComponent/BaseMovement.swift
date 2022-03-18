import CoreGraphics

class BaseMovement: Movement {
    let nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(entity: Entity, deltaTime: CGFloat) {

    }
}
